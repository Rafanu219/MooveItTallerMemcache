require_relative 'multiclient_tcp_server'
require_relative 'business_logic'

srv = MulticlientTCPServer.new( 2000, 2000, true )
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
              sock.write "es get\n"
            when "gets"
              sock.write "es gets\n"
            when "set"
              response = businessLogic.validate_set_command(request)
              puts "Antes de if"
              if response.success == true
                puts "despues de if"
                value = sock.gets( "\r\n" ).chomp( "\r\n" )
                puts request
                puts value
                response = businessLogic.set(request,value)
                if response.success == true
                  sock.write response.message + "\n"
                else
                  sock.write response.message + "\n"
                end
              else
                sock.write response.message + "\n"
              end
            when "append"
              sock.write "es append\n"
            when "prepend"
              sock.write "es prepend\n"
            when "add"
              sock.write "es add\n"
            when "cas"
              sock.write "es cas\n"
            when "replace"
              sock.write "es replace\n"
            when "quit"
              raise SystemExit
            else 
              sock.write "ERROR\n"
            end
    else
        sleep 0.01 # free CPU for other jobs, humans won't notice this latency
    end
end