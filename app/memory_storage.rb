require_relative 'key'
require_relative 'response'

class MemoryStorage
    attr_accessor :key_list, :modification_counter

    def initialize
        @key_list = {}
        @modification_counter = 0
    end

    def set(name,attribute_retiever,value)
        self.delete_all_expired_keys
        self.modification_counter = self.modification_counter + 1
        t = Time.now + attribute_retiever.time
        expire_time = attribute_retiever.time
        key = Key.new(name,attribute_retiever.flag,t,attribute_retiever.bits,value,self.modification_counter,expire_time)
        self.key_list.delete(name)
        self.key_list.store(name,key)
        return Response.new(MESSAGE_STORED,true)
    end

    def add(name,attribute_retiever,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            return Response.new("KEY ALREADY EXIST",false)
        else
            self.modification_counter = self.modification_counter + 1
            t = Time.now + attribute_retiever.time
            expire_time = attribute_retiever.time
            key = Key.new(name,attribute_retiever.flag,t,attribute_retiever.bits,value,self.modification_counter,expire_time)
            self.key_list.store(name,key)
            return Response.new(MESSAGE_STORED,true)
        end
    end

    def replace(name,attribute_retiever,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.set(name,attribute_retiever,value)
        else
            return Response.new(MESSAGE_KEY_DOES_NOT_EXIST,false)
        end
    end
    

    def append(name,bits,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.modification_counter = self.modification_counter + 1
            key = self.key_list[name]
            key.modification_value = self.modification_counter
            new_value = key.value + value
            key.value = new_value
            key.bits = key.bits + bits
            return Response.new(MESSAGE_STORED,true)
        else
            return Response.new(MESSAGE_KEY_DOES_NOT_EXIST,false)
        end
    end

    def prepend(name,bits,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.modification_counter = self.modification_counter + 1
            key = self.key_list[name]
            key.modification_value = self.modification_counter
            new_value = value + key.value
            key.value = new_value
            key.bits = key.bits + bits
            return Response.new(MESSAGE_STORED,true)
        else
            return Response.new(MESSAGE_KEY_DOES_NOT_EXIST,false)
        end
    end

    def cas(name,attribute_retiever,value,modification_value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            key = self.key_list[name]
            if modification_value == key.modification_value
                self.set(name,attribute_retiever,value)
            else
                return Response.new("EXIST",true)
            end
        else
            return Response.new(MESSAGE_KEY_DOES_NOT_EXIST,false)
        end
    end

    def get(request)
        self.delete_all_expired_keys
        i = 1
        n = request.length
        message = ""
        while i <= n do
            name = request[i]
            key = self.key_list[name]
            i = i + 1
            if key != nil
                message =  message + "VALUE #{key.key_name} #{key.flag} #{key.bits}\n#{key.value}\n" 
            end
        end
        message = message + "END"
        return Response.new(message,true)
    end

    def gets(request)
        self.delete_all_expired_keys
        i = 1
        n = request.length
        message = ""
        while i <= n do
            name = request[i]
            key = self.key_list[name]
            i = i + 1
            if key != nil
                message =  message + "VALUE #{key.key_name} #{key.flag} #{key.bits} #{key.modification_value}\n#{key.value}\n"
            end
        end
        message = message + "END"
        return Response.new(message,true)
    end

    def key_exist(name)
        key = self.key_list[name]
        if key != nil
            return true
        else
            return false
        end
    end
        
    def delete_all_expired_keys
        key_list.each { |name, key|
            if key.expires
                t = Time.now
                is_expired = key.time <=> t
                if  is_expired == -1
                    self.key_list.delete(name)
                end
            end
        }
    end
    
end

