# Load the rails application
require File.expand_path('../application', __FILE__)

# Source credentials and encryption keys
Rails.root.join('secrets.rb').tap do |secrets|
  load(secrets) if File.exists?(secrets)
end

# Initialize the rails application
MeetingLibs::Application.initialize!
