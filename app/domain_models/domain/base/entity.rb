module Domain::Base
  class Entity < FieldsObject
    FILED_CLASS_HASH = {}
    FIELDS = []

    class << self
      def empty_build
        filelds_for_initialize = self::FILED_CLASS_HASH.map do |_, value_class|
          if value_is_child_of_class?(value_class, ValueObject)
            value_class.empty_build
          else
            nil
          end
        end
        self.new(*filelds_for_initialize)
      end

      private
  
      def attr_updater(*fields)
        fields.map(&:to_sym).each do |entity_field|
          define_method("update_#{entity_field}") do |arg|
            update_field(arg, "@#{entity_field}")
          end
        end
      end
    end

    def initialize(*field_value_args, field_list: self.class::FIELDS)
      field_values = field_value_args.zip(self.class::FILED_CLASS_HASH.values).map do |field_value, value_class|
        next field_value unless field_value.nil?
        
        if self.class.send(:value_is_child_of_class?, value_class, ValueObject)
          value_class.empty_build
        else
          nil
        end
      end

      super(*field_values, field_list: field_list)
    end

    # TODO: 「=」メソッドを定義。既存の=でimmutableは実現できるけどdirtyかどうかを認識できるように。値が入っていた場合updateで異なる属性更新を行う

    def update_field(arg, instance_variable_name_for_update)
      current_value_object = instance_variable_get(instance_variable_name_for_update)

      new_value_object = if updating_with_fields_object?(arg)
                            update_value_object_fields(arg.to_h, current_value_object)
                          elsif updating_one_or_more_fields_with_hash?(arg)
                            update_value_object_fields(arg, current_value_object)
                          elsif arg.nil?
                            update_fields_with_nil_value(current_value_object)
                          elsif updating_one_field_without_hash_for_one_field_value_object?(arg, current_value_object.update_methods)
                            update_value_object_field(current_value_object, current_value_object.update_methods.first.to_sym, arg)
                          else
                            raise ArgumentError, "引数の指定方法が不正です。複数フィールドを持つ値オブジェクトの更新時にはキーワード引数を使用してください。"
                          end
      instance_variable_set(instance_variable_name_for_update, new_value_object)
    end

    def changed_fields
      fields(only_exist_field: true).reduce({}) do |result, (field_name, field_value)|
        next result if field_value.is_a?(ValueObject) && field_value.changed_fields.empty?

        result[field_name] = field_value
        result
      end
    end

    def nil_entity?
      fields.all? do |_, v|
        nil_object?(v)
      end
    end

    private

    def updating_one_field_without_hash_for_one_field_value_object?(arg, value_object_update_methods)
      value_object_update_methods.size == 1 && arg.class != Hash
    end

    def updating_with_fields_object?(arg)
      arg.is_a?(FieldsObject)
    end

    def updating_one_or_more_fields_with_hash?(arg)
      arg.class == Hash
    end

    def update_value_object_fields(update_fields, value_object_for_update)
      update_fields.reduce(value_object_for_update) do |value_object, (value_object_field, value_object_value_for_update)|
        update_value_object_field(value_object, "update_#{value_object_field}".to_sym, value_object_value_for_update)
      end
    end

    def update_fields_with_nil_value(value_object_for_update)
      value_object_for_update.update_methods.reduce(value_object_for_update) do |value_object, update_method|
        update_value_object_field(value_object, update_method, nil)
      end
    end

    # TODO: 値が変わっていないときには更新しないようにエンティティか値オブジェクトで調整
    def update_value_object_field(value_object, update_method_name, update_value)
      raise ::Domain::Base::NoFieldError, value_object_field unless value_object.update_methods.include?(update_method_name.to_sym)

      value_object.send(update_method_name, update_value)
    end
  end
end