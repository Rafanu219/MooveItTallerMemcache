require_relative 'key'
require_relative 'response'

class MemoryStorage
    attr_accessor :key_list, :modification_counter

    def initialize
        @key_list = []
        @modification_counter = 0
    end

    def set(name,attribute_retiever,value)
        self.delete_all_expired_keys
        self.modification_counter = self.modification_counter + 1
        t = Time.now + attribute_retiever.time
        key = Key.new(name,attribute_retiever.flag,t,attribute_retiever.bits,value,self.modification_counter)
        self.delete_key(name)
        self.key_list.push(key)
        return Response.new("STORED",true)
    end

    def add(name,attribute_retiever,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            return Response.new("KEY ALREADY EXIST",false)
        else
            self.modification_counter = self.modification_counter + 1
            t = Time.now + attribute_retiever.time
            key = Key.new(name,attribute_retiever.flag,t,attribute_retiever.bits,value,self.modification_counter)
            self.key_list.push(key)
            return Response.new("STORED",true)
        end
    end

    def replace(name,attribute_retiever,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.set(name,attribute_retiever,value)
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end
    

    def append(name,bits,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.modification_counter = self.modification_counter + 1
            key = self.retrieve_key(name)
            key.modification_value = self.modification_counter
            new_value = key.value + value
            key.value = new_value
            key.bits = key.bits + bits
            return Response.new("STORED",true)
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end

    def prepend(name,bits,value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            self.modification_counter = self.modification_counter + 1
            key = self.retrieve_key(name)
            key.modification_value = self.modification_counter
            new_value = value + key.value
            key.value = new_value
            key.bits = key.bits + bits
            return Response.new("STORED",true)
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end

    def cas(name,attribute_retiever,value,modification_value)
        self.delete_all_expired_keys
        if self.key_exist(name)
            key = self.retrieve_key(name)
            if modification_value == key.modification_value
                self.set(name,attribute_retiever,value)
            else
                return Response.new("EXIST",true)
            end
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end

    def get(keyName)
        self.delete_all_expired_keys
        key = key_list.find { |key| key.key_name == keyName }
        if key != nil
            message =  "VALUE #{key.key_name} #{key.flag} #{key.bits} \n#{key.value} \nEND"
            return Response.new(message,true)
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end

    def gets(keyName)
        self.delete_all_expired_keys
        key = key_list.find { |key| key.key_name == keyName }
        if key != nil
            message =  "VALUE #{key.key_name} #{key.flag} #{key.bits} #{key.modification_value}\n#{key.value} \nEND"
            return Response.new(message,true)
        else
            return Response.new("KEY DOES NOT EXIST",false)
        end
    end

    def delete_key(keyName)
        key_list.delete_if { |key| key.key_name == keyName }
    end

    def key_exist(keyName)
        key = key_list.find { |key| key.key_name == keyName }
        if key != nil
            return true
        else
            return false
        end
    end

    def retrieve_key(keyName)
        return key_list.find { |key| key.key_name == keyName }
    end
        
    def delete_all_expired_keys
        key_list.each { |key| self.delete_expired_key(key) }
    end

    def delete_expired_key(key)
        t = Time.now
        is_expired = key.time <=> t
        if  is_expired == -1
            self.delete_key(key.key_name)
        end
    end
end
