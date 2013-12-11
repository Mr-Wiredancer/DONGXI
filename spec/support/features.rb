require "#{Rails.root}/spec/support/features/session_helpers.rb"

RSpec.configure do |config|
	config.include Features::SessionHelpers, type: :feature
end
