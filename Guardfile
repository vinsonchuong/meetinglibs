notification :tmux, display_message: true, color_location: ''

guard 'spork' do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('config/routes.rb')
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', cli: '--drb --format documentation' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)\.erb$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$}) { 'spec' }
  watch('config/routes.rb') { 'spec/routing' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }

  # Capybara features specs
  # watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) { |m| "spec/features/#{m[1]}_spec.rb" }
end

guard :jasmine do
  watch(%r{spec/javascripts/spec\.js$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.js$})
  watch(%r{app/assets/javascripts/(.+?)\.js(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.js" }
end

