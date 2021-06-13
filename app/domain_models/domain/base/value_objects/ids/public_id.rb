module Domain::Base::ValueObjects::Ids
  class PublicId < BaseId
    # NOTE private_idと違って、外部(URLやレスポンス)にID晒していいやつ。わかりやすくするためにURL用のラベルのフィールドを作るかも
  end
end