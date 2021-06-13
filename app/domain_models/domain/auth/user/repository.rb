module Domain::Auth::User
  class Repository < ::Domain::Base::Repository
    class << self
      def build_id_from_id_param(id_param)
        build_id_from_record(::User.find_by(id_param: id_param))
      end
      def build_id_from_id_value(id_value)
        build_id_from_record(::User.find(id_value))
      end

      def fetch_id_value_from_id_param(id_param)
        ::User.find_by(id_param: id_param)&.id
      end

      private

      def build_id_from_record(record)
        raise "指定したユーザが存在しません。" if record.nil?
        Id.new(record.id, record.id_param)
      end
    end
  end
end