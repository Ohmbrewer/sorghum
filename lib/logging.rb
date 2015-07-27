require 'json'
module Sorghum

  # Logs an event and its payload in convenient ways
  # @param [String] event_name The name of the event type
  # @param [JSON] payload The payload to record
  def log_event(event_name, payload)

    # Report to the server log
    if payload.nil? || payload.empty?
      logger.info "[#{event_name}]: <<NO PAYLOAD>>"
    else
      logger.info "[#{event_name}]: #{payload}"
    end

    # Also update the Last Event file
    root_dir = "#{File.expand_path(File.dirname(__FILE__))}/.."
    last_event_file = "#{root_dir}/logs/last_#{event_name}_event.log"
    File.open(last_event_file, 'w') do |f|
      f.print payload.to_json
    end

  end

  # Reads back the message from the Last Event file, if possible
  # @param [String] event_name The name of the event type
  # @return [String|nil] The message from the Last Event file or nil if the file doesn't exist
  def last_event_for(event_name)
    root_dir = "#{File.expand_path(File.dirname(__FILE__))}/.."
    last_event_file = "#{root_dir}/logs/last_#{event_name}_event.log"

    File.exists?(last_event_file) ? File.read(last_event_file) : nil
  end

end