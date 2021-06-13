module Domain::Base
  class CommandResult
    STATUS_SUCCESS = "STATUS_SUCCESS"

    attr_reader :status

    class << self
      def build_success_result
        new()
      end
    end

    def initialize(status: STATUS_SUCCESS, error: nil)
      @status = status
      @error = error # [型] string:エラーメッセージ string:[]エラーメッセージ配列 ※その他は独自型設定
    end

    def success?
      @status == STATUS_SUCCESS
    end

    def error_message(sep: " ")
      case @error
      when Array
        @error.join(sep)
      else
        # そのまま値を返す。String,NilClassの場合もそのまま返す。
        @error
      end
    end
  end
end