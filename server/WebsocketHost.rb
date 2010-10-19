require 'Communicator'
require 'Client'

module EventMachine
  
  class ClientNotFoundException < RuntimeError
    attr_reader :player_id
    def initialize(player_id)
      @player_id = player_id
    end
  end
  
  class HostNotFoundException < RuntimeError
    attr_reader :game_id
    def initialize(game_id)
      @game_id = game_id
    end
  end
  
  class WebsocketHost < Communicator
    
    @@games = {}
    attr_reader :id
    
    def initialize(websocket)
      super # init communicator
      @id = generate_unique_id
      @players = {}
      @channel = EM::Channel.new
      # send created id to game
      send(@id)
      # add game to games hash
      @@games[@id] = self
    end
    
    def add_player(websocket)
      # add player socket to channel and use channel id as player id
      player_id = @channel.subscribe { |msg| websocket.send msg }
      # save new instance of player
      @players[player_id] = Player.new(self, player_id, websocket)
      # notify the game of new player
      send "#{player_id} connected"
    end
    
    def remove_player(player)
      @channel.unsubscribe(player.id)
      @players.delete(player.id)
      send "#{player.id} disconnected"
    end
    
    def to_game(msg)
      send(msg)
    end
    
    def to_all(msg)
      @channel.push message # push message to all players
    end
    
    def to_player(player_id, message)
      unless(@players[player_id])
        raise PlayerNotFoundException(player_id)
      end
        # send message to player's websocket
        @players[player_id].send(message);
        p "game > #{player_id}: #{message}"
    end
    
    protected
    
    def close(msg)
      @@games.delete(@id)
    end
    
    def self.generate_unique_id
      uid = rand(100)
      while(@@games[uid])
        uid = rand(100)
      end
      return uid.to_s
    end
    
    def self.get_game(id)
      unless(@@games[id])
        raise GameNotFoundException(id)
      end
      @@games[id]
    end
    
  end
end