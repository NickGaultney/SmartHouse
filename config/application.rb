require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Template
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.autoload_paths += %W(#{config.root}/lib)
    config.assets.precompile += %w( '.svg' )  

    # Must include to get inline SVGs to work in deploy
    config.assets.css_compressor = :sass
    #config.eager_load_paths += %W(#{config.root}/app/models/io_device)
    #config.eager_load_paths += %W(#{config.root}/app/models/input)
    #config.eager_load_paths += %W(#{config.root}/app/models/output)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
