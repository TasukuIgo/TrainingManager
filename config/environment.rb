# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# リバースプロキシ（Nginx）経由でも CSRF トークンが一致するように
Rails.application.config.action_controller.default_url_options = {
  host: 'localhost',  # ブラウザからアクセスするホスト
  port: 8080          # Nginxで割り当てたポート
}
