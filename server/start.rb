require 'rubygems'
require 'em-websocket'

require 'WebsocketHost'
require 'WebsocketClient'
require 'HostFactory'

EventMachine.run {

  EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 10_000, :debug => true) do |ws|
    
    # handle connection requests
    ws.onopen {
      # analyse request path to differentiate between clients and games
      game = ws.request["Path"].match /game/
      if(game)
        game = EventMachine::HostFactory.add_host(ws)
        
        # HOST MESSAGES
        
        game.onmessage do |msg|
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
            rescue EventMachine::ClientNotFoundException => exception
              game.send("exception:clientNotFound #{client_id}")
            end # rescue
          end
        end # block
        
        game.onclose do
          EventMachine::HostFactory.remove_host(game.id)
        end
        
        game.send(game.id)
        
      else
        # connecting route - /game_id/connect 
        connect = ws.request["Path"].match /(\d*)\/connect\/([a-zA-Z0-9 ]*)/
        if(connect)
          game_id = connect[1]
          deviceType = connect[2]
          game = EventMachine::HostFactory.get_host(game_id)
          client = game.add_client(ws, deviceType)
          
          # CLIENT MESSAGES
          
          client.onmessage do |msg|
            # message to host
            if(host = msg.match /game (.*)/)
              message = host[1] # extracted message
              game.to_host("#{client.id} #{message}")

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
                rescue EventMachine::ClientNotFoundException => exception
                  client.send("exception:clientNotFound #{client.id}")
                end # rescue
            end # if (host)
          end # client.onmessage
          
          client.onclose do
            client.send("game closed")
            game.send("#{client.id} disconnected")
          end
          
          game.send("#{client.id} connected")
          client.send(client.id)
          
        else
          ws.close_with_error("connect to game like this: /*i/connect")
        end
      end
    }
    
  end

  puts "Server started"

}
