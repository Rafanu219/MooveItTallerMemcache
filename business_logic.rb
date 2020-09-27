require_relative 'response'
require_relative 'memory_storage'
require_relative 'constants'

class BusinessLogic
    attr_accessor :memStorage

    def initialize
        @memStorage = MemoryStorage.new
    end


    def set(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            flag = self.parse_flag(request[2])
            time = self.parse_time(request[3])
            bits = self.parse_bits(request[4])
            return memStorage.set(keyName,flag,time,bits,value)
        else
            return Response.new("ERROR",false)
        end
    end

    def check_range(flag,time,bits)
        if flag >= 0 && flag <MAXIMUM_FLAG && time > 0 && time < MAXIMUM_TIME && bits > 0 && bits < MAXIMUM_BITS_SIZE
            return true
        else
            return false
        end
    end

    def validate_set_command(request)
        if request.length != 5
            return Response.new("ERROR",false)
        end
        flag = self.parse_flag(request[2])
        time = self.parse_time(request[3])
        bits = self.parse_bits(request[4])
        if self.check_range(flag,time,bits)
            return Response.new("SUCCESS",true)
        else
            return Response.new("ERROR",false)
        end
    end

    def validate_value(request,value)
        bits = self.parse_bits(request[4])
        if value.length != bits
            return false
        end
        return true
    end

    def parse_flag(flag)
        begin
            parsedFlag = Integer(flag)
            rescue
                return Response.new("ERROR",false)
        end
    end

    def parse_time(time)
        begin
            parsedTime = Integer(time)
            rescue
                return Response.new("ERROR",false)
        end
    end

    def parse_bits(bits)
        begin
            parsedBits = Integer(bits)
            rescue
                return Response.new("ERROR",false)
        end
    end
end