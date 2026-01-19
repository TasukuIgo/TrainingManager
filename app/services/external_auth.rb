# app/services/external_auth/authenticate.rb
module ExternalAuth
  class Authenticate
    class AuthError < StandardError; end

    def initialize(login_name:, password:)
      @login_name = login_name
      @password   = password
    end

    def call
      response = authenticate_with_external_api

      raise AuthError, "認証失敗" unless response[:success]

      {
        external_user_id: response[:id],          # ← 認証用外部主キー
        login_name:       response[:name],        # ← ログインID
        real_name:        response[:real_name]    # ← 表示名
      }
    end

    private

    def authenticate_with_external_api
      # 実際は Api::UsersController#authenticate を叩く
      # test用ダミー
      {
        success: true,
        id: 123,
        name: "yamada",          # user_name
        real_name: "山田 太郎"
      }
    end
  end
end
