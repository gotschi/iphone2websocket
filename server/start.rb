require 'rubygems'
require 'em-websocket'

require 'Host'
require 'Client'
require 'HostManager'

EventMachine.run {

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 10_000, :debug => true) do |websocket|
    
    # handle connection requests
    websocket.onopen {
      # analyse request path to differentiate between clients and games
      game = websocket.request["Path"].match /game/
      if(game)
        game = EventMachine::Websocket::HostManager.add_host(websocket)
        
        # HOST MESSAGES
        game.websocket.onmessage do |msg|
          # message to all clients
          if(all = msg.match /all (.*)/)
            message = all[1] # extracted message
            game.to_all("game #{message}")

          # message to individual client
          elsif(client = msg.match /(\d*) (.*)/)
            client_id = client[1]
            message = client[2]
            begin
              game.to_client(client_id, "game #{message}")
            rescue EventMachine::Websocket::ClientNotFoundException => exception
              game.websocket.send("exception:clientNotFound #{client_id}")
            end # rescue
          end
        end # block
        
        game.websocket.onclose do
          EventMachine::Websocket::HostManager.remove_host(game.id)
        end
        
        game.websocket.send(game.id)
        
      else
        # connecting route - /game_id/connect 
        connect = websocket.request["Path"].match /(\d*)\/connect\/([a-zA-Z0-9 ]*)/
        
        if(connect)
          game_id = connect[1]
          deviceType = connect[2]
          game = EventMachine::Websocket::HostManager.get_host(game_id)
          client = game.add_client(websocket, deviceType)
          
          # CLIENT MESSAGES
          
          client.websocket.onmessage do |msg|
            # message to host
            if(host = msg.match /game (.*)/)
              message = host[1] # extracted message
              game.websocket.send("#{client.id} #{message}")

            # message to all clients
            elsif(all = msg.match /all (.*)/)
              message = all[1] # extracted message
              game.to_all("#{client.id} #{message}")

            # message to individual client
            elsif(msg_to_client = msg.match /(\d*) (.*)/)
                other_client_id = msg_to_client[1]
                message = msg_to_client[2]
                begin
                  game.to_client(other_client_id, "#{client.id} #{message}")
                rescue EventMachine::Websocket::ClientNotFoundException => exception
                  client.websocket.send("exception:clientNotFound #{client.id}")
                end # rescue
            end # if (host)
          end # client.onmessage
          
          client.websocket.onclose do
            client.websocket.send("game closed")
            game.websocket.send("#{client.id} disconnected")
          end
          
          game.websocket.send("#{client.id} connected #{deviceType}")
          client.websocket.send(client.id)
          
        else
          websocket.close_with_error("connect to game like this: /*i/connect")
        end
      end
    }
    
  end

  puts "Server started"

}
