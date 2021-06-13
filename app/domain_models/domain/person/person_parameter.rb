module Domain::Person
  class PersonParameter
    # * 役割
    # FactoryやCommandに対する引数が多すぎるため、クラス化
    # * 取りうる選択肢
    # 1. 基底クラスで基本、継承クラスで差分のフィールド作る
    # 2. パラメータが必要なところでそれぞれ継承なくパラメータクラスを作る(n重管理)
    # →基本1でやりたい。
    # * 現状
    # 基底クラスをPersonの基本パラメータとしたらid_paramとかも入り、Parameterを使うCreateCommandで使わないものが基底に入ってしまう
    # * 暫定対応
    # 全部のせの基底パラメータクラスを用意する。
    # そのCommandで使うパラメータはCommandかCommand用のパラメータクラスでassertする。
    # * 恒久対応希望
    # n重管理しなくていいきれいな命名や継承構造を作れたら、それでリファクタリングする

    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id_param, :string

    attribute :disp_name, :string
    
    attribute :first_name, :string
    
    attribute :last_name, :string
    
    attribute :middle_name, :string
    
    attribute :kana, :string
    
    attribute :birth_sex_code, :integer
    validates :birth_sex_code, inclusion: { in: Sex::SEX_CODES.values }, allow_nil: true
    
    attribute :desired_sex_code, :integer
    validates :desired_sex_code, inclusion: { in: Sex::SEX_CODES.values }, allow_nil: true
    
    attribute :birth_year, :integer
    validates :birth_year, length: { in: 3..4 }, allow_nil: true
    
    attribute :birth_month, :integer
    validates :birth_month, length: { in: 1..2 }, allow_nil: true
    
    attribute :birth_date, :integer
    validates :birth_date, length: { in: 1..2 }, allow_nil: true
    
    attribute :belonging_person_group_id_param, :string
    
    attribute :accessible_user_id_param, :string
    
    attribute :regist_user_self_person, :boolean, default: false
    
    def any_sex_code_present?
      birth_sex_code.present? # birth_sex_codeがDBの必須項目。desired_sex_codeは付帯
    end

    def any_birth_date_value_present?
      birth_year.present? || birth_month.present? || birth_date.present?
    end

    # TODO: 日付が揃っている場合2021/2/31など不正な日付(Date.newでエラーになる)を弾くカスタムバリデーションを組む
  end
end