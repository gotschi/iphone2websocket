require 'Communicator'
require 'WebsocketHost'

module EventMachine
  class WebsocketClient < Communicator
    
    @@connectionCount = 0
    attr_reader :id
    attr_reader :type
    
    def initialize(game, player_id, websocket, type)
      super(websocket) # init communicator
      @game = game
      @id = player_id
      @type = type
      @@connectCount += 1
    end
    
    def to_game(msg)
      @game.send("#{@id} #{msg}")
    end
    
    def to_all(msg)
      @game.to_all("#{@id} #{msg}")
    end
    
    def to_player(player_id, msg)
      @game.to_player(player_id, "#{@id} #{msg}")
    end
    
    def close(msg)
      @game.removePlayer(self)
      @@connectionCount -= 1
    end
    
  end
end