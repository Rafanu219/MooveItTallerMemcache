class AttributeRetriever

    attr_accessor :flag, :time, :bits

    def initialize(flag,time, bits)
        @flag = flag
        @time = time
        @bits = bits
    end
end