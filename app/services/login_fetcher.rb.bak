require 'net/http'
require 'uri'
require 'json'

class LoginFetcher
  LOGIN_CHECK_URL = 'https://fundely.co.jp/api/users/check_sign_in_needed'.freeze
  API_KEY         = '72457d584a138ac880a6a1fea0534b99'.freeze

  def self.fetch_user_info(user_id: nil, user_name: nil)
    return nil if user_id.blank? && user_name.blank?

    uri = URI.parse(LOGIN_CHECK_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.open_timeout = 5
    http.read_timeout = 5

    request = Net::HTTP::Post.new(uri.path)
    request['X-API-KEY'] = API_KEY
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = URI.encode_www_form(user_id: user_id, user_name: user_name)

    response = http.request(request)
    return nil unless response.code.to_i == 200

    body = JSON.parse(response.body)
    return nil if body['need_sign_in']

    {
      user_id:   user_id,
      user_name: user_name,
      real_name: body['real_name']
    }
  rescue StandardError => e
    Rails.logger.warn("Fundely API fetch_user_info failed: #{e.class} #{e.message}")
    nil
  end
end
