require 'sinatra/base'
require 'json'

module Sorghum

  module Routes

    # Our root route should just tell you a thing or
    # two about this application
    Sinatra::Base::get '/' do
      json APP_INFO
    end

    Sinatra::Base::not_found do
      status 404
      content_type :json
      {error: 'Path not found. Sorry dude.'}.to_json
    end

    # A list of paths that should consume webhook events
    WEBHOOK_ROUTES = %w(pumps temps thermostats ferms stills).freeze

    # For each of the webhook-consuming paths, accept a JSON payload
    WEBHOOK_ROUTES.each do |route|

      # POST requests sent to /ROUTE will consumed as JSON webhooks
      Sinatra::Base::post "/#{route}" do
        status 204 # Respond with a successful request with no body content

        # Get dat body
        request.body.rewind
        request_payload = ''
        begin
          dat_body = request.body.read
          request_payload = JSON.parse dat_body
        rescue JSON::JSONError
          # If we got here, they probably didn't send us a JSON.
          logger.error "Received a bad request to the /#{route} route. Looks like: \"#{dat_body}\""
          status 405
          content_type :json
          {error: 'JSON! DO. YOU. SPEAK IT!?!'}.to_json
        end

        # Append the payload to a file
        log_event route, request_payload
      end

      # GET requests sent to /last/ROUTE will return
      # the last message received at /ROUTE or
      # 503 if the file isn't there
      Sinatra::Base::get "/last/#{route}" do
        last_event_msg = last_event_for route
        if last_event_msg.nil?
          status 503
          content_type :json
          {error: 'The webhook event result file is missing. ' <<
                  'Maybe you haven\'t triggered that one yet?'}.to_json
        else
          content_type :json
          last_event_msg.chomp.to_json
        end
      end

    end

  end
end


