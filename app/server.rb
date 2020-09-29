require_relative 'multiclient_tcp_server'
require_relative 'business_logic'

srv = MulticlientTCPServer.new( 2121, 3600, true )
businessLogic = BusinessLogic.new

loop do
    if sock = srv.get_socket
        # a message has arrived, it must be read from sock
        message = sock.gets( "\r\n" ).chomp( "\r\n" )
        # arbitrary examples how to handle incoming messages:
            request = message.split
            command = request[0]
            case command
            when "get"
              response = businessLogic.validate_retrieval_command(request)
              if response.success == true
                response = businessLogic.get(request)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "gets"
              response = businessLogic.validate_retrieval_command(request)
              if response.success == true
                response = businessLogic.gets(request)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "set"
              response = businessLogic.validate_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.set(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "append"
              response = businessLogic.validate_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.append(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "prepend"
              response = businessLogic.validate_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.prepend(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "add"
              response = businessLogic.validate_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.add(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "cas"
              response = businessLogic.validate_cas_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.cas(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "replace"
              response = businessLogic.validate_storage_command(request)
              if response.success == true
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                response = businessLogic.replace(request,value)
                sock.write response.message + "\n"
              else
                sock.write response.message + "\n"
              end
            when "quit"
              raise SystemExit
            else 
              sock.write "ERROR\n"
            end
    else
        sleep 0.01 # free CPU for other jobs, humans won't notice this latency
    end
end