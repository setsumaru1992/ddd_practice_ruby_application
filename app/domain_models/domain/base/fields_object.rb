module Domain::Base
  class FieldsObject
    FIELDS = []

    class << self
      def empty_array_of_field
        Array.new(self::FIELDS.size)
      end

      def empty_build
        raise NotImplementedError
      end

      private

      def value_is_child_of_class?(value, klass)
        if value.class == Class
          value.ancestors.include?(klass)
        else
          value.is_a?(klass)
        end
      end
    end

    def initialize(*field_values, field_list: self.class::FIELDS)
      initialize_fields(field_list, field_values)
    end

    def [](field)
      raise_error_if_field_not_exist(field)
      instance_variable_get("@#{field}")
    end

    def []=(field, value)
      raise_error_if_field_not_exist(field)
      instance_variable_set("@#{field}", value)
    end

    def to_h
      self.class::FIELDS.reduce({}) do |result, field|
        result[field] = instance_variable_get("@#{field}")
        result
      end
    end

    def ==(obj)
      exist_not_equal_field = self.class::FIELDS.any? do |field|
        next true if obj.nil?
        
        self[field] != obj[field]
      end
      !exist_not_equal_field
    end

    def fields(only_exist_field: false)
      field_hash = self.to_h
      return field_hash unless only_exist_field

      field_hash.delete_if {|_, v| nil_object?(v)}
      field_hash
    end

    private

    def initialize_fields(field_list, field_values)
      field_list.zip(field_values).each do |field, field_value|
        raise_error_if_field_not_exist(field)
        instance_variable_set("@#{field}", field_value)
      end
    end

    def raise_error_if_field_not_exist(field)
      raise ::Domain::Base::NoFieldError, field unless self.class::FIELDS.include?(field)
    end

    def nil_object?(value)
      if value.is_a?(ValueObject)
        value.nil_value?
      else
        value.nil?
      end
    end
  end
end