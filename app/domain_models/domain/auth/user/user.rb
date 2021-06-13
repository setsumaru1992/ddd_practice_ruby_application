module Domain::Auth::User
  class User < ::Domain::Base::Entity
    FILED_CLASS_HASH = {
      id: Id,
    }
    FIELDS = FILED_CLASS_HASH.keys
    attr_accessor *FIELDS
  end
end