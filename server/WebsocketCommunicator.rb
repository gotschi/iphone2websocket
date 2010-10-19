module EventMachine
  class WebsocketCommunicator
    
    def initialize(websocket)
      @websocket = websocket
      # setup websocket message handling
      setup_onmessage
      setup_onclose
    end
    
    def send(msg)
      @websocket.send(msg)
    end
    
    def close(msg)
      send(msg)
    end
    
    protected
    
    def setup_onmessage
      @websocket.onmessage do |msg|
        
        # message to game
        game = msg.match /game (.*)/
        if(game)
          message = game[1] # extracted message
          to_game(message)
        end
        
        # message to all players
        all = msg.match /all (.*)/
        if(all)
          message = all[1] # extracted message
          to_all(message)
        end

        # message to individual player
        player = msg.match /(\d*) (.*)/
        if(player)
          player_id = player[1]
          message = player[2]
          begin
            to_player(player_id, message)
          rescue PlayerNotFoundException => exception
            @websocket.send("exception:playerNotFound #{exception.player_id}")
          end # rescue
        end # if
      end # block
      
    end # setup_onmessage
    
    def setup_onclose
      @websocket.onclose do |msg|
        close(msg)
      end
    end
  end
end