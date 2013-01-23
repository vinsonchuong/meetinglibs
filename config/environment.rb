# Load the rails application
require File.expand_path('../application', __FILE__)

# Source credentials and encryption keys
secrets = Rails.root.join('secrets.rb')
load(secrets) if File.exists?(secrets)

# Initialize the rails application
MeetingLibs::Application.initialize!
