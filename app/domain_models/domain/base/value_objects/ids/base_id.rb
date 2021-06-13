module Domain::Base::ValueObjects::Ids
  class BaseId < ::Domain::Base::ValueObject
    attr_accessor :fetched_record

    class << self
      def build_by_record(record)
        raise NotImplementedError
      end
    end
  end
end