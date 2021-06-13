module Domain::Person::Group
  class Finder::FetchGroupsFinder < ::Domain::Base::Finder
    attribute :access_user_id, :integer
    validates :access_user_id, presence: true

    def fetch
      # 指定ユーザのレコードに限定
      # relation = 
      # 階層ごと取得
      # relation = 
    end
  end
end