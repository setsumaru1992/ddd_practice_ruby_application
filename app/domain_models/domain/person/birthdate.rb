module Domain::Person
  class Birthdate < ::Domain::Base::ValueObject
    FIELDS = %I(year month date)
    attr_reader *FIELDS
    attr_updater *FIELDS

    def exist_full_date?
      @year.present? && @month.present? && @date.present?
    end

    def to_date
      return unless exist_full_date?
      Date.new(@year, @month, @date)
    end
  end
end