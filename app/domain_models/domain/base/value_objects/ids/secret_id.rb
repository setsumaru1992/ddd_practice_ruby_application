module Domain::Base::ValueObjects::Ids
  class SecretId < PrivateId
    FIELDS = %I(id id_param)
    attr_reader *FIELDS
    attr_updater *FIELDS

    class << self
      def build_by_record(record)
        id = self.new(record.id, record.id_param)
        id.fetched_record = record
        id
      end
    end

    def generate_id_param
      # TODO: 16桁の英字(大文字・小文字)・数字の文字列を生成する（DBにアクセスしてユニークかどうか確認する）
      SecureRandom.alphanumeric
    end

    def value
      @id
    end

    def param
      @id_param
    end
  end
end