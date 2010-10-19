require 'rubygems'
require 'em-websocket'

require 'Host'
require 'Client'

EventMachine.run {

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 10_000, :debug => true) do |ws|
    
    # handle connection requests
    ws.onopen {
      # analyse request path to differentiate between clients and games
      game = ws.request["Path"].match /game/
      if(game)
        createGame(ws)
      else
        # connecting route - /game_id/connect 
        connect = ws.request["Path"].match /(\d*)\/connect\/([a-zA-Z0-9 ]*)/
        if(connect)
          game_id = connect[1]
          iModel = connect[2]
          connectPlayer(game_id, iModel, ws)
        else
          ws.close_with_error("connect to game like this: /*i/connect")
        end
      end
    }
    
  end

  puts "Server started"

}
