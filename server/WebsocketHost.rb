require 'WebsocketClient'

module EventMachine
  
  class ClientNotFoundException < RuntimeError
    attr_reader :client_id
    def initialize(client_id)
      @client_id = client_id
    end
  end
  
  class WebsocketHost
    
    attr_reader :id
    
    def initialize(id, websocket)
      @id = id
      @websocket = websocket
      @clients = {}
      @channel = EM::Channel.new
    end
    
    def send(msg)
      @websocket.send(msg)
    end
    
    def add_client(websocket, type)
      # add client socket to channel and use channel id as client id
      client_id = @channel.subscribe { |msg| websocket.send msg }
      client_id = client_id.to_s
      # save new instance of client
      @clients[client_id] = WebsocketClient.new(self, client_id, websocket, type)
    end
    
    def remove_client(client)
      @channel.unsubscribe(client.id)
      client.close
      @clients.delete(client.id)
    end
    
    def remove_clients
      @clients.each do |key, client|
        client.close_with_error("clients removed")
      end
    end
    
    def to_host(message)
      send(message)
    end
    
    def to_all(message)
      @channel.push message # push message to all clients
    end
    
    def to_client(client_id, message)
      unless(@clients[client_id])
        raise ClientNotFoundException.new(client_id)
      end
        # send message to client's websocket
        @clients[client_id].send(message);
        p "host > #{client_id}: #{message}"
    end
    
    def onmessage(&block)
      @onmessage = block
      @websocket.onmessage do |msg|
        @onmessage.call(msg)
      end
    end
    
    def onclose(&block)
      @onclose = block
      @websocket.onclose do
        @onclose.call
      end
    end
    
  end
end