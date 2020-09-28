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

    def add(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            flag = self.parse_flag(request[2])
            time = self.parse_time(request[3])
            bits = self.parse_bits(request[4])
            return memStorage.add(keyName,flag,time,bits,value)
        else
            return Response.new("ERROR",false)
        end
    end

    def replace(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            flag = self.parse_flag(request[2])
            time = self.parse_time(request[3])
            bits = self.parse_bits(request[4])
            return memStorage.replace(keyName,flag,time,bits,value)
        else
            return Response.new("ERROR",false)
        end
    end

    def append(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse_bits(request[4])
            return memStorage.append(keyName,bits,value)
        else
            return Response.new("ERROR",false)
        end
    end

    def prepend(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse_bits(request[4])
            return memStorage.prepend(keyName,bits,value)
        else
            return Response.new("ERROR",false)
        end
    end

    def cas(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            flag = self.parse_flag(request[2])
            time = self.parse_time(request[3])
            bits = self.parse_bits(request[4])
            modification_value = self.parse_modification_value(request[5])
            return memStorage.cas(keyName,flag,time,bits,value,modification_value)
        else
            return Response.new("ERROR",false)
        end
    end

    def get(request)
        keyName = request[1]
        return memStorage.get(keyName)
    end

    def gets(request)
        keyName = request[1]
        return memStorage.gets(keyName)
    end

    def check_range(flag,time,bits)
        if flag >= 0 && flag <MAXIMUM_FLAG && time > 0 && time < MAXIMUM_TIME && bits > 0 && bits < MAXIMUM_BITS_SIZE
            return true
        else
            return false
        end
    end

    def validate_storage_command(request)
        if request.length != 5
            return Response.new("ERROR",false)
        end
        flag = self.parse_flag(request[2])
        time = self.parse_time(request[3])
        bits = self.parse_bits(request[4])
        if self.check_range(flag,time,bits)
            return Response.new("SUCCESS",true)
        else
            return Response.new("ERROR: Flag,time or bits exeeded maximum",false)
        end
    end

    def validate_cas_storage_command(request)
        if request.length != 6
            return Response.new("ERROR",false)
        end
        flag = self.parse_flag(request[2])
        time = self.parse_time(request[3])
        bits = self.parse_bits(request[4])
        modification_value = self.parse_modification_value(request[5])
        if self.check_range(flag,time,bits)
            return Response.new("SUCCESS",true)
        else
            return Response.new("ERROR: Flag,time or bits exeeded maximum",false)
        end
    end

    def validate_retrieval_command(request)
        if request.length != 2
            return Response.new("ERROR",false)
        end
        return Response.new("SUCCES",true)
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
                return Response.new("ERROR: Flag must be an integer",false)
        end
    end

    def parse_time(time)
        begin
            parsedTime = Integer(time)
            rescue
                return Response.new("ERROR: Time must be an integer",false)
        end
    end

    def parse_bits(bits)
        begin
            parsedBits = Integer(bits)
            rescue
                return Response.new("ERROR: Bits must be an integer",false)
        end
    end

    def parse_modification_value(mod_value)
        begin
            modification_value = Integer(mod_value)
            rescue
                return Response.new("ERROR: Modification value must be an integer",false)
        end
    end
end