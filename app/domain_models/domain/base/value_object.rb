module Domain::Base
  class ValueObject < FieldsObject
    # NOTE: 
    # - 変化があったカラムを記録するフィールド。変化があったフィールドのみDB更新
    # - 新規作成時は変更ではないので空配列
    attr_reader :changed_fields

    FIELDS = []

    class << self
      def build_from_model(model, fields: self::FIELDS)
        values = fields.map {|field| model[field]}
        new(*values)
      end

      def build_empty_object
        values = Array.new(self::FIELDS.size)
        new(*values)
      end

      def empty_build
        self.new(*empty_array_of_field)
      end

      private

      # 次のようなメソッドを定義 new_date = date.update_month(11)
      def attr_updater(*attrs)
        attrs.map(&:to_sym).each do |defining_attr|

          define_method("update_#{defining_attr}") do |defining_value|
            raise_error_if_field_not_exist(defining_attr)

            values = attrs.map { |attribute| attribute == defining_attr ? defining_value : instance_variable_get("@#{attribute}")}
            changed_fields = @changed_fields.include?(defining_attr) ? @changed_fields : @changed_fields + [defining_attr]
            self.class.new(*values, changed_fields: changed_fields)
          end

        end
      end
    end

    # NOTE
    # - 基本的に値オブジェクト側ではFIELDSとアクセサだけ定義させる
    # - initializeは親のこのクラスの物を使わせる。
    # - initializeの独自実装をするのは可能。しかしその場合、値オブジェクト側からこの親クラスのinitializeを使うだけで、値オブジェクト使用者にはこのクラスのinitializeを直接は使わせない
    #   - changed_fieldsなどの変更は内部でのみ行う
    #   - 値オブジェクト自体の初期化引数はできるだけ単純になるようにケア
    def initialize(*field_values, field_list: self.class::FIELDS, changed_fields: [])
      super(*field_values, field_list: field_list)
      @changed_fields = changed_fields
    end

    def update_methods
      self.methods.select {|m| (m =~ /^update_/).present? } - [:update_methods]
    end

    def nil_value?
      fields.all? {|_, v| v.nil?}
    end

    def present_value?
      any_value_present?
    end

    def any_value_present?
      !nil_value?
    end

    def all_value_present?
      fields.all? {|_, v| !v.nil?}
    end
  end
end