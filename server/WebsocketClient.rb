require 'WebsocketHost'

module EventMachine
  
  class WebsocketClient
    
    @@connectionCount = 0
    attr_reader :id
    attr_reader :type
    
    def initialize(host, client_id, websocket, type)
      @websocket = websocket
      @host = host
      @id = client_id
      @type = type
      @@connectionCount += 1
    end
    
    def send(msg)
      @websocket.send(msg)
    end
    
    def close_with_error(msg)
      @websocket.close_with_error(msg)
    end
    
    def onmessage(&block)
      @onmessage = block
      @websocket.onmessage do |msg|
        @onmessage.call(msg)
      end
    end
    
    def onclose(&block)
      @@connectionCount -= 1
      @onclose = block
      @websocket.onclose do
        @onclose.call
      end
    end
    
  end
end