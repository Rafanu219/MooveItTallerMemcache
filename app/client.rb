require 'socket'
require 'timeout'

# connect to server

sock = begin
           Timeout::timeout( 1 ) { TCPSocket.open( 'localhost', 2121 ) }
       rescue StandardError, RuntimeError => ex
           raise "cannot connect to server: #{ex}"
       end

# send sample messages:
puts "sending a request that should be answered"
sock.write( "set rafa 1 80 4\r\nrafa\r\n" )
response = begin
               Timeout::timeout(5) { sock.gets( "\n" ).chomp( "\n" ) }
           rescue StandardError, RuntimeError => ex
               raise "no response from server: #{ex}"
           end
puts "received response: '#{response}'"
puts "quit"
sock.close