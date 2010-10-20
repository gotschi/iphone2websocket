module EventMachine
  module Websocket
    
    class Client
    
      @@clientCount = 0
      attr_reader :id
      attr_reader :type
      attr_reader :websocket
    
      def initialize(id, websocket, type)
        @websocket = websocket
        @id = id
        @type = type
        @@clientCount += 1
      end
    end
    
  end
end