module Domain::Person
  class Name < ::Domain::Base::ValueObject
    FIELDS = %I(disp_name last_name first_name middle_name kana)
    attr_reader *FIELDS
    attr_updater *FIELDS
  end
end