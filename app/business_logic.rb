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
            attribute_retiever = self.create_attribute_retriever(request)
            return memStorage.set(keyName,attribute_retiever,value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
        end
    end

    def add(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            return memStorage.add(keyName,attribute_retiever,value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
        end
    end

    def replace(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            return memStorage.replace(keyName,attribute_retiever,value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
        end
    end

    def append(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse_bits(request[4])
            return memStorage.append(keyName,bits,value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
        end
    end

    def prepend(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse_bits(request[4])
            return memStorage.prepend(keyName,bits,value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
        end
    end

    def cas(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            modification_value = self.parse_modification_value(request[5])
            return memStorage.cas(keyName,attribute_retiever,value,modification_value)
        else
            return Response.new("ERROR: The value does not match bits requested",false)
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

    def check_range(attribute_retiever)
        if attribute_retiever.flag >= 0 && attribute_retiever.flag <MAXIMUM_FLAG && attribute_retiever.time > 0 && attribute_retiever.time < MAXIMUM_TIME && attribute_retiever.bits > 0 && attribute_retiever.bits < MAXIMUM_BITS_SIZE
            return true
        else
            return false
        end
    end

    def validate_storage_command(request)
        if request.length != 5
            return Response.new("ERROR: Wrong number of arguments",false)
        end
        attribute_retiever = self.create_attribute_retriever(request)
        if self.check_range(attribute_retiever)
            return Response.new("SUCCESS",true)
        else
            return Response.new("ERROR: Flag,time or bits exeeded maximum or where less than 0",false)
        end
    end

    def validate_cas_storage_command(request)
        if request.length != 6
            return Response.new("ERROR: Wrong number of arguments",false)
        end
        attribute_retiever = self.create_attribute_retriever(request)
        modification_value = self.parse_modification_value(request[5])
        if self.check_range(attribute_retiever)
            return Response.new("SUCCESS",true)
        else
            return Response.new("ERROR: Flag,time or bits exeeded maximum or where less than 0",false)
        end
    end

    def validate_retrieval_command(request)
        if request.length != 2
            return Response.new("ERROR: Wrong number of arguments",false)
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

    def create_attribute_retriever(request)
        flag = self.parse_flag(request[2])
        time = self.parse_time(request[3])
        bits = self.parse_bits(request[4])
        return AttributeRetriever.new(flag,time,bits)
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