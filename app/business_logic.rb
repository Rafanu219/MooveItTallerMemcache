require_relative 'response'
require_relative 'memory_storage'
require_relative 'constants'
require_relative 'attribute_retriever'

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
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def add(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            return memStorage.add(keyName,attribute_retiever,value)
        else
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def replace(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            return memStorage.replace(keyName,attribute_retiever,value)
        else
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def append(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse(request[4])
            return memStorage.append(keyName,bits,value)
        else
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def prepend(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            bits = self.parse(request[4])
            return memStorage.prepend(keyName,bits,value)
        else
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def cas(request,value)
        if self.validate_value(request,value)
            keyName = request[1]
            attribute_retiever = self.create_attribute_retriever(request)
            modification_value = self.parse(request[5])
            return memStorage.cas(keyName,attribute_retiever,value,modification_value)
        else
            return Response.new(MESSAGE_ERROR_VALUE_DOES_NOT_MATCH_BITS,false)
        end
    end

    def get(request)
        return memStorage.get(request)
    end

    def gets(request)
        return memStorage.gets(request)
    end

    def check_range(attribute_retiever)
        if attribute_retiever.flag >= 0 && attribute_retiever.flag <MAXIMUM_FLAG && attribute_retiever.time > -1 && attribute_retiever.time < MAXIMUM_TIME && attribute_retiever.bits > 0 && attribute_retiever.bits < MAXIMUM_BITS_SIZE
            return true
        else
            return false
        end
    end

    def validate_storage_command(request)
        if request.length != 5
            return Response.new(MESSAGE_ERROR_WRONG_NUMBER_OF_ARGUMENTS,false)
        end
        if is_number?(request[2]) && is_number?(request[3]) && is_number?(request[4])
            attribute_retriever = self.create_attribute_retriever(request)
            if self.check_range(attribute_retriever)
                return Response.new(MESSAGE_SUCCESS,true)
            else
                return Response.new(MESSAGE_ERROR_EXEEDED_MAXIMUM_OR_LESS_THAN_0,false)
            end
        else
            return Response.new(MESSAGE_ERROR,false)
        end
    end

    def validate_cas_storage_command(request)
        if request.length != 6
            return Response.new(MESSAGE_ERROR_WRONG_NUMBER_OF_ARGUMENTS,false)
        end
        if is_number?(request[2]) && is_number?(request[3]) && is_number?(request[4]) && is_number?(request[5])
            attribute_retriever = self.create_attribute_retriever(request)
            modification_value = self.parse(request[5])
            if self.check_range(attribute_retriever)
                return Response.new(MESSAGE_SUCCESS,true)
            else
                return Response.new(MESSAGE_ERROR_EXEEDED_MAXIMUM_OR_LESS_THAN_0,false)
            end
        else
            return Response.new(MESSAGE_ERROR,false)
        end
    end

    def validate_retrieval_command(request)
        if request.length <= 1
            return Response.new(MESSAGE_ERROR_WRONG_NUMBER_OF_ARGUMENTS,false)
        end
        return Response.new(MESSAGE_SUCCESS,true)
    end

    def validate_value(request,value)
        bits = self.parse(request[4])
        if value.length != bits
            return false
        end
        return true
    end

    def create_attribute_retriever(request)
        flag = self.parse(request[2])
        time = self.parse(request[3])
        bits = self.parse(request[4])
        return AttributeRetriever.new(flag,time,bits)
    end

    def is_number? (string)
        true if Integer(string) rescue false
    end
      
    def parse(data)
        return Integer(data)
    end
end