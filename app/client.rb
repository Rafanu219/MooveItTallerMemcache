require "socket"
s = TCPSocket.open("localhost", 2121)
s.write( "set rafa 1 10000 7\r\nrafa\nel\r\n")
response = s.gets( "\n" ).chomp( "\n" )
puts "received response #{response}"
s.write( "get rafa\r\n")
puts "received response:"
line = s.gets
puts "#{line}"
line = s.gets
puts "#{line}"
line = s.gets
puts "#{line}"
line = s.gets
puts "#{line}"
s.close