require 'Client'

module EventMachine
  module Websocket
    
    class ClientNotFoundException < RuntimeError
      attr_reader :client_id
      def initialize(client_id)
        @client_id = client_id
      end
    end
  
    class Host
    
      @@hostCount = 0
      attr_reader :id
      attr_reader :websocket
    
      def initialize(id, websocket)
        @websocket = websocket
        @id = id
        @clients = {}
        @channel = EM::Channel.new
        @@hostCount += 1
      end
    
      def add_client(websocket, type)
        # add client socket to channel and use channel id as client id
        client_id = @channel.subscribe { |msg| websocket.send msg }
        client_id = client_id.to_s
        # save new instance of client
        @clients[client_id] = Client.new(client_id, websocket, type)
      end
    
      def remove_client(client_id)
        @channel.unsubscribe(client_id)
        client.websocket.close_with_error("removed")
        @clients.delete(client_id)
      end
    
      def remove_clients
        @clients.each do |key, client|
          client.websocket.close_with_error("removed")
        end
      end
    
      def to_all(message)
        @channel.push message # push message to all clients
      end
    
      def to_client(client_id, message)
        unless(@clients[client_id])
          raise ClientNotFoundException.new(client_id)
        end
          # send message to client's websocket
          @clients[client_id].websocket.send(message);
          p "host > #{client_id}: #{message}"
      end
    end
  end
end