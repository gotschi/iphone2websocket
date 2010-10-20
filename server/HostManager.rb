require 'Host'

module EventMachine
  module Websocket
    
    class HostNotFoundException < RuntimeError
      attr_reader :host_id
      def initialize(host_id)
        @host_id = host_id
      end
    end
  
    class HostManager
      @@hosts = {}
    
      # begin static class methods
      class << self
      
        def add_host(websocket)
          uid = generate_unique_id
          @@hosts[uid] = Host.new(uid, websocket)
        end
      
        def remove_host(id)
          unless(@@hosts[id])
            raise HostNotFoundException.new(id)
          end
          @@hosts[id].remove_clients
          @@hosts.delete(id)
        end
      
        def get_host(id)
          unless(@@hosts[id])
            raise HostNotFoundException.new(id)
          end
          @@hosts[id]
        end
      
        protected
      
        def generate_unique_id
          uid = rand(1000)
          while(@@hosts[uid])
            uid = rand(1000)
          end
          return uid.to_s
        end

      end # class << self
    end
  end
end