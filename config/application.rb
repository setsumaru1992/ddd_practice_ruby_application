require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DddPracticeRubyApplication
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    config.time_zone = "Asia/Tokyo"

    config.encoding = "utf-8"

    config.autoload_paths += %W(#{config.root}/app/domain_models)

    config.generators do |g|
      g.stylesheets false
      g.javascripts false
      g.helper false
      # g.template_engine false # 結局作るようなroutingなんてデバッグ用だからHTMLあってほしい
      g.test_framework false
      # g.factory_bot false # テスト作るときには必要だから。自作を面倒
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"

        resource "*",
                 headers: :any,
                 methods: [:get, :post, :put, :patch, :delete, :options, :head],
                 expose: ['Per-Page', 'Total', 'Link']
      end
    end
  end
end
