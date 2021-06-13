module Domain::Person::Finder
  class FetchMatchPersonsFinder < ::Domain::Base::Finder
    attribute :access_user_id, :integer
    validates :access_user_id, presence: true
    # TODO: orderとかは
    # - [[:id,:desc], :name]みたいにする可能性が高い
    # - プリミティブ型で定義できない形にしそうだからattr_accessorで定義
    # - カスタムバリデーションで整合性チェック

    def fetch
      # 1. そのユーザが取れるPersonを全取得
      relation = ::Person.user_accessible_persons(access_user_id)
      # 2. 返却するフィールドを定義
      relation = declear_output_fields(relation)
      # 3. 条件に合うものに絞る（グループも属性として捉える）
      relation = filter(relation)
      # 4. ソート(デフォルトはグループ)
      relation = sort(relation)

      arrange_relation_for_output_values(relation)
    end

    def declear_output_fields(relation)
      # NOTE: 使い回すようになったらVIEW作成
      relation
        .left_outer_joins(:person_name)
        .left_outer_joins(:person_birthdate)
        .left_outer_joins(:person_sex)
        .left_outer_joins(:person_group_belonging)
        .joins(%Q(
          LEFT OUTER JOIN person_group_hierarchies
            ON person_group_hierarchies.top_group_id = person_group_belongings.person_group_id
              OR person_group_hierarchies.middle_group_id = person_group_belongings.person_group_id
              OR person_group_hierarchies.bottom_group_id = person_group_belongings.person_group_id
        ))
        .select("
            people.id
            , person_names.disp_name
            , person_names.last_name
            , person_names.first_name
            , person_names.middle_name
            , person_names.kana
            , person_birthdates.year AS birth_year
            , person_birthdates.month AS birth_month
            , person_birthdates.date AS birth_date
            , person_sexes.birth_sex_code
            , person_sexes.desired_sex_code
            , person_group_hierarchies.top_group_name
            , person_group_hierarchies.middle_group_name
            , person_group_hierarchies.bottom_group_name
          ")
    end

    def filter(relation)
      relation
    end

    def sort(relation)
      # NOTE: グループソートはデフォルト。条件によって変える
      relation.order(
        :top_group_name,
        :middle_group_name,
        :bottom_group_name,
        :disp_name
      )
    end

    def arrange_relation_for_output_values(relation)
      relation.map(&:attributes)
    end
    
  end
end