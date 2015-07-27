require_relative '../sorghum'
require 'minitest/autorun'
require 'rack/test'

class RoutesTest < Minitest::Test
  include Rack::Test::Methods

  def app
    SorghumApp
  end

  def test_app_info
    get '/'
    assert_equal app::APP_INFO,
                 JSON.parse(last_response.body,
                            symbolize_names: true)
  end

  def test_webhook_routes
    app::Routes::WEBHOOK_ROUTES.each do |route|
      test_msg = "{\"test\":\"true\"}"

      # Send a message
      post route, test_msg
      assert_equal 204, last_response.status

      # Check that it was actually received
      get "/last/#{route}"
      assert_equal 200, last_response.status
      assert_equal test_msg.to_json, last_response.body
    end
  end

  def test_webhook_routes_reject_non_json
    app::Routes::WEBHOOK_ROUTES.each do |route|
      # Text
      post route,  'ALL YOUR BASE!'
      assert_equal 405, last_response.status

      # XML
      post route,  '<!DOCTYPE _[<!ELEMENT _ EMPTY>]><_/>'
      assert_equal 405, last_response.status

      # YAML
      post route,  'request_is: bad'
      assert_equal 405, last_response.status
    end
  end

end