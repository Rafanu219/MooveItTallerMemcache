class Response
    attr_accessor :message, :success

    def initialize(message,success)
        @message = message
        @success = success
    end

end