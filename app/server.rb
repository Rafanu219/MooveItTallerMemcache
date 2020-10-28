require 'socket'
require_relative 'business_logic'
class Server
  server = TCPServer.new(2121)
  businessLogic = BusinessLogic.new

  loop do
    Thread.start(server.accept) do |connection|
      while line = connection.gets
        break if line =~ "quit"
        request = line.split
        command = request[0]
        case command
        when "get"
          response = businessLogic.validate_retrieval_command(request)
          if response.success == true
              response = businessLogic.get(request)
              connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "gets"

          response = businessLogic.validate_retrieval_command(request)
          if response.success == true
            response = businessLogic.gets(request)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "set"
          response = businessLogic.validate_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.set(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "append"
          response = businessLogic.validate_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.append(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "prepend"
          response = businessLogic.validate_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.prepend(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "add"
          response = businessLogic.validate_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.add(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "cas"
          response = businessLogic.validate_cas_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.cas(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        when "replace"
          response = businessLogic.validate_storage_command(request)
          if response.success == true
            value = connection.gets( "\r\n" ).chomp( "\r\n" )
            response = businessLogic.replace(request,value)
            connection.puts response.message + "\n"
          else
              connection.puts response.message + "\n"
          end
        else 
          connection.puts "ERROR\n"
        end
      end
    end
  end
end