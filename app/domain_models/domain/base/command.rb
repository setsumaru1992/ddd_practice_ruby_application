module Domain::Base
  class Command
    include ActiveModel::Model
    include ActiveModel::Attributes

    # TODO: conditionsで指定されない場合と値がnilで指定された場合が区別できない問題を解消したい
    # - 案1: 値を区別する
    # - 案2: 必ず値を入れさせるように強制する(現状コントローラーでは値入れるようにしているけど、テストでは値はいらないことも想定して偶然動くテストしてるから薄氷の前提。)
    def self.call(**conditions)
      command = new(conditions)
      command.call
    end

    def initialize(conditions)
      super(conditions)
      raise_error unless valid?
    end

    private_class_method :new

    def call
      raise NotImplementedError
    end

    def raise_error
      raise errors.full_messages.join(", and ")
    end
  end
end