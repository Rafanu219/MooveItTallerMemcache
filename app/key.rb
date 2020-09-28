class Key


    attr_accessor :key_name, :flag, :time, :bits, :value, :modification_value

    def initialize(name,flag,time, bits,value,modification_value)
        @key_name = name
        @flag = flag
        @time = time
        @bits = bits
        @value = value
        @modification_value = modification_value
    end
end