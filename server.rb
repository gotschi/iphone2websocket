require 'rubygems'
require 'em-websocket'


EventMachine.run {
  #@channel = EM::Channel.new
  @games = {};
  
  def generate_game_id
    uid = rand(999999)
    while(@games[uid])
      uid = rand(999999)
    end
    return uid.to_s
  end
  
  def createGame(ws)
    id = generate_game_id
    @games[id] = { :game => ws, :player => {}, :channel => EM::Channel.new }
    ws.send(id) # send created id to game
    p "new game started: #{id}"
    
    # handle game messages
    ws.onmessage { |msg|
      
      # message to all players
      all = msg.match /all (.*)/
      if(all)
        message = all[1]
        @games[id][:channel].push message # push message to all players
        p "game > all: #{message}"
      end
      
      # message to individual player
      player = msg.match /(\d*) (.*)/
      if(player)
        sid = player[1]
        message = player[2]
        if(@games[id][:player][sid])
          # send message to player's websocket
          @games[id][:player][sid].send(message);
          p "game > #{individual[1]}: #{message}"
        end
      end
    }
    
    # game close handler
    ws.onclose { |msg|
=begin
      @games[id][:player].each do |client|
        p "closing #{client}"
      end
       @games.delete(id) # remove game
=end
    }
  end
  
  def connectPlayer(id, ws)
    
    # player wants to connect to game
    if(@games[id])
      # player is connected
      sid = @games[id][:channel].subscribe { |msg| ws.send msg } # add player to channel
      @games[id][:player][sid] = ws # save player connection
      @games[id][:game].send "#{sid} connected"
      ws.send sid # send player its subscriber id
      
      # handle player message
      ws.onmessage { |msg|
        # send message to game
        @games[id][:game].send "#{sid} #{msg}"
      }
      
      # handle player disconnect
      ws.onclose { 
        @games[id][:game].send "#{sid} disconnected"
        @games[id][:channel].unsubscribe(sid)
        @games[id][:player].delete(sid)
      }
      
    else
      #ws.close_with_error("no game with id: " + id)
    end

  end
  
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 10_000, :debug => true) do |ws|
    
    # handle connection requests
    ws.onopen {
      # analyse request path to differentiate between clients and games
      game = ws.request["Path"].match /game/
      if(game)
        createGame(ws)
      else
        # connecting route - /game_id/connect 
        connect = ws.request["Path"].match /(\d*)\/connect/
        if(connect)
          game_id = connect[1]
          connectPlayer(game_id, ws)
        else
          ws.close_with_error("connect to game like this: /*i/connect")
        end
      end
    }
    
  end

  puts "Server started"

}
