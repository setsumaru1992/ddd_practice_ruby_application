module Domain::Base::ValueObjects::Ids
  class InternalId < PrivateId
    # 公開したくないIDではあるが、内部的にのみ使われ、URLなどに公開されないために、難読化などが必要でないID
    FIELDS = %I(id)
    attr_reader *FIELDS
    attr_updater *FIELDS

    class << self
      def build_by_record(record)
        id = self.new(record.id)
        id.fetched_record = record
        id
      end
    end

    def value
      @id
    end
  end
end