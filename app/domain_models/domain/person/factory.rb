module Domain::Person
  class Factory < ::Domain::Base::Factory
    class << self
      def build(person_parameter)
        person = Person.empty_build

        person.name = Name.new(
          person_parameter.disp_name,
          person_parameter.last_name,
          person_parameter.first_name,
          person_parameter.middle_name,
          person_parameter.kana,
        )

        if person_parameter.any_sex_code_present?
          person.sex = Sex.new(person_parameter.birth_sex_code, person_parameter.desired_sex_code)
        end

        if person_parameter.any_birth_date_value_present?
          person.birthdate = Birthdate.new(
            person_parameter.birth_year,
            person_parameter.birth_month,
            person_parameter.birth_date
          )
        end

        if person_parameter.belonging_person_group_id_param.present?
          person.person_group_id = ::Domain::Person::Group::Repository.build_id_from_id_param(person_parameter.belonging_person_group_id_param)
        end
        person.accessible_user_id = ::Domain::Auth::User::Repository.build_id_from_id_param(person_parameter.accessible_user_id_param)

        person
      end
    end
  end
end