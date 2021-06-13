module Domain::Base::ValueObjects::Ids
  class MasterNum < PublicId
    # NOTE
    # IDと同じくユニークにレコードを指す参照識別子だが、RailsのIDはサロゲートキーで連番で振られるという意味を持ったパワーワードであり、
    # 四則演算したり2の倍数であることに意味があるなど、数字自体に意味をもたせたいが、誤解を招く可能性があるため、それらが行なえ、ID的な意味を持てる言葉としてnumを採用した
    FIELDS = %I(num)
    attr_reader *FIELDS
    attr_updater *FIELDS

    class << self
      def build_by_record(record)
        num = self.new(record.num)
        num.fetched_record = record
        num
      end
    end

    def value
      @num
    end
  end
end