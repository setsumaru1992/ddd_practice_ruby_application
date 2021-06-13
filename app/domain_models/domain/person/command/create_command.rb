module Domain::Person
  class Command::CreateCommand < Domain::Base::Command
    def initialize(conditions)
      @param = Paramater.new(**conditions)
      raise_error unless @param.valid?
    end
    
    def call
      person = Factory.build(@param)

      ActiveRecord::Base.transaction do
        if @param.regist_user_self_person
          person.id = Repository.add_user_self_person(person)
        else
          person.id = Repository.add(person)
        end
      end
      person
    end

    class Paramater < PersonParameter
      validates :disp_name, presence: true
      validates :accessible_user_id_param, presence: true
    end
  end
end