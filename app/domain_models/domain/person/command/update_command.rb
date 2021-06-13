module Domain::Person
  class Command::UpdateCommand < Domain::Base::Command
    def initialize(conditions)
      @param = Paramater.new(**conditions)
      raise_error unless @param.valid?
    end

    def call
      existing_person = Repository.find_by_id_param(@param.id_param)
      updated_person = update_fields(existing_person)
      Repository.update(updated_person)
    end

    private

    def update_fields(person)
      updated_name = Name.new(
        @param.disp_name,
        @param.last_name,
        @param.first_name,
        @param.middle_name,
        @param.kana,
      )
      person.update_name(updated_name) if person.name != updated_name

      updated_sex = Sex.new(
        @param.birth_sex_code,
        @param.desired_sex_code,
      )
      person.update_sex(updated_sex) if person.sex != updated_sex
      
      updated_birthdate = Birthdate.new(
        @param.birth_year,
        @param.birth_month,
        @param.birth_date,
      )
      person.update_birthdate(updated_birthdate) if person.birthdate != updated_birthdate

      updated_person_group_id = if @param.belonging_person_group_id_param.present?
        ::Domain::Person::Group::Repository.build_id_from_id_param(@param.belonging_person_group_id_param)
      else
        ::Domain::Person::Group::Id.empty_build
      end
      person.update_person_group_id(updated_person_group_id) if person.person_group_id != updated_person_group_id
      
      person
    end

    class Paramater < PersonParameter
      validates :id_param, presence: true
    end
  end
end