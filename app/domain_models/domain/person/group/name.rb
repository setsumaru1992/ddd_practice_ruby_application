module Domain::Person::Group
  class Name < ::Domain::Base::ValueObject
    FIELDS = %I(name)
    attr_reader *FIELDS
    attr_updater *FIELDS

    def value
      @name
    end
  end
end