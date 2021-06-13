module Domain::Person::Group
  class Group < ::Domain::Base::Entity
    FILED_CLASS_HASH = {
      id: Id,
      name: Name,
      parent_group_id: Id,
      accessible_user_id: ::Domain::Auth::User::Id,
    }
    FIELDS = FILED_CLASS_HASH.keys
    attr_accessor *FIELDS
    attr_updater *FIELDS
  end
end