module Domain::Person
  class Sex < ::Domain::Base::ValueObject
    SEX_CODES = {
      MAN: 1,
      WOMAN: 2,
    }

    SEX_LABELS = {
      SEX_CODES[:MAN] => "男",
      SEX_CODES[:WOMAN] => "女",
    }

    FIELDS = %I(birth_sex_code desired_sex_code)
    attr_reader *FIELDS
    attr_updater *FIELDS
    
  end
end