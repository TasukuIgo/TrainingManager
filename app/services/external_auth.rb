module ExternalAuth
  class Authenticate
    class AuthError < StandardError; end
      
      #初めてのログイン
      def initialize(login_name:, password:)
        @login_name = login_name
        @password   = password
      end
      
      #２回目以降のログイン
      def call
        response = authenticate_with_external_api

        raise AuthError, "認証失敗" unless response[:success]

        {
          external_user_id: response[:id],          # ← 認証用外部主キー
          login_name:       response[:login_name],        # ← ログインID
          real_name:        response[:real_name]    # ← 表示名
        }
      end

    private

    def authenticate_with_external_api
      # ダミー認証条件
      if @login_name == "yamada" && @password == "password"
        {
          success: true,
          id: 123,
          name: "yamada",
          real_name: "山田 太郎"
        }
      else
        {
          success: false
        }
      end
    end
  end
end