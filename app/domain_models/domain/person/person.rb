module Domain::Person
  class Person < ::Domain::Base::Entity
    FILED_CLASS_HASH = {
      id: Id,
      name: Name,
      sex: Sex,
      birthdate: Birthdate,
      person_group_id: ::Domain::Person::Group::Id,
      accessible_user_id: ::Domain::Auth::User::Id,
    }
    FIELDS = FILED_CLASS_HASH.keys
    attr_accessor *FIELDS
    attr_updater *FIELDS
  end
end