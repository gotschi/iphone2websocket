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
    return uid
  end
  
  def createGame
    id = generate_game_id
    @games[id] = { :game => ws, :player => {}, :channel => EM::Channel.new }
    ws.send(id) # send created id to game
    
    # handle game messages
    ws.onmessage { |msg|
      # channel routing
      
      # message to all players
      all = msg.match /all (\w*)/
      if(all)
        @games[id][:channel].push all[1] # push message to all players
      end
      
      # message to individual player
      id = msg.match /(\d*) (\w*)/
    }
    
    # game close handler
    ws.onclose { |msg|
      
    }
  end
  
  def connectPlayer
    
    # player wants to connect to game
    
    id = connect[1]; # extract id
    if(@games[id])
      # player is connected
      ws.send "ok" 
      sid = @games[id][:channel].subscribe { |msg| ws.send msg } # add player to channel
      @games[id][:player][sid] = ws # save player connection
      # handle player message
      ws.onmessage { |msg|
        
      }
      
      # handle player disconnect
      ws.onclose { |msg| 
        
      }
      
    else
      ws.close_with_error("no game with id: " + id)
    end

  end
  
  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 10_000, :debug => true) do |ws|
    
    # handle connection requests
    ws.onopen {
      # analyse request path to differentiate between clients and games
      game = ws.request["Path"].match /game/
      if(game)
        createGame
      else
        # connecting route - /game_id/connect 
        connect = ws.request["Path"].match /(\d*)\/connect/
        if(connect)
          connectPlayer
        end
      end
      
      #@sid = @channel.subscribe { |msg| ws.send msg }
      #@channel.push "#{@sid} connected!"
    }
    
  end

  puts "Server started"
=begin
  Thread.new do
     while(true) do
        @channel.push("Server: ping")
        sleep 1
      end
  end
=end
}
