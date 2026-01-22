module ExternalAuth
  class Authenticate
    class AuthError < StandardError; end
    class ConnectionError < StandardError; end
    class TimeoutError    < StandardError; end
      
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
      case @login_name
      when "yamada"
        return { success: @password == "password", id: 123, login_name: "yamada", real_name: "山田 太郎" }
      when "instructor"
        return { success: @password == "password", id: 1, login_name: "instructor", real_name: "テスト用講師" }
      when "user"
        return { success: @password == "password", id: 2, login_name: "user", real_name: "テスト用一般ユーザー" }
      else
        return { success: false }
      end
    end
  end
end