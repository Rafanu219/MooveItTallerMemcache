class Key

    attr_accessor :key_name, :flag, :time, :bits, :value, :modification_value, :expire_time,:expires

    def initialize(name,flag,time, bits,value,modification_value,expire_time)
        @key_name = name
        @flag = flag
        @time = time
        @bits = bits
        @value = value
        @modification_value = modification_value
        if expire_time == 0
            @expires = false
        else
            @expires = true
        end
    end
end