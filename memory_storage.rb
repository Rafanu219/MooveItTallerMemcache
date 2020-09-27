require_relative 'key'
require_relative 'response'

class MemoryStorage
    attr_accessor :key_list, :modification_counter

    def initialize
        @key_list = []
        @modification_counter = 0
    end

    def set(name,flag,time,bits,value)
        self.modification_counter = self.modification_counter + 1
        t = Time.now + time
        puts t
        key = Key.new(name,flag,t,bits,value,self.modification_counter)
        self.delete_key(name)
        self.key_list.push(key)
        return Response.new("STORED",true)
    end

    def add(name,flag,time,bits,value)
        if self.key_exist(name)
            return Response.new("LA KEY QUE DESEA CREAR YA EXISTE",false)
        else
            self.modification_counter = self.modification_counter + 1
            t = Time.now + time
            key = Key.new(name,flag,t,bits,value,self.modification_counter)
            self.key_list.push(key)
            return Response.new("STORED",true)
        end
    end

    def get(keyName)
        key = key_list.find { |key| key.key_name == keyName }
        if key != nil
            message =  "VALUE #{key.key_name} #{key.flag} #{key.bits} \n#{key.value}"
            return Response.new(message,true)
        else
            return Response.new("NO SE ENCONTRO NINGUNA KEY CON ESE NOMBRE",false)
        end
    end

    def gets(keyName)
        key = key_list.find { |key| key.key_name == keyName }
        if key != nil
            message =  "VALUE #{key.key_name} #{key.flag} #{key.bits} #{key.modification_value}\n#{key.value}"
            puts message
            return Response.new(message,true)
        else
            return Response.new("NO SE ENCOTRO NINGUNA KEY CON ESE NOMBRE",false)
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

    def delete_all_expired_keys
        key_list.each { |key| self.delete_expired_key(key) }
    end

    def delete_expired_key(key)
        t = Time.now
        puts t
        is_expired = key.time <=> t
        if  is_expired == -1
            self.delete_key(key.key_name)
        end
    end
end

#firstSet = MemoryStorage.new()
#firstSet.set("rafa",0,90,4,"weno")
#firstSet.set("pepe",0,1,4,"lala")
#firstSet.set("lola",0,90,4,"popo")
#puts firstSet.key_list
#value = gets.chomp
#firstSet.delete_all_expired_keys()
#puts firstSet.key_list
