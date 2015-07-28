require 'json'
module Sorghum

  module Logging

    # A Hash of the last event received for each path
    Sinatra::Base::set :last_event_for, Hash.new

    # Logs an event and its payload in convenient ways
    # @param [String] event_name The name of the event type
    # @param [String] payload The payload to record
    def log_event_for(event_name, payload)

      # Report to the server log
      if payload.nil? || payload.empty?
        logger.info "[#{event_name}]: <<NO PAYLOAD>>"
      else
        logger.info "[#{event_name}]: #{payload}"
      end

      # Save the payload to a application-global variable for getting the last submissions
      Sinatra::Base.settings.last_event_for[event_name] = payload.to_json
    end

    # @param [String] event_name The name of the event to retrieve the last submission for
    # @return [String] JSON formatted string representing the last submission
    def last_event_for(event_name)
      Sinatra::Base.settings.last_event_for[event_name]
    end

  end

end