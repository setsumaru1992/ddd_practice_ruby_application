module Domain::Base
  class NoFieldError < ::NoMethodError
    def initialize(undefined_field)
      error_message = "undedined field '#{undefined_field.to_s}'"
      super(error_message)
    end
  end
end