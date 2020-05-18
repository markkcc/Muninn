# https://bloggie.io/@kinopyo/heroku-free-dyno-with-cloudflare-free-ssl
# https://github.com/rails/rails/issues/22965#issuecomment-568655496
#
# Proxying to Heroku via Cloudflare can cause TLS related issues
# Use this if you are getting errors like ActionController::InvalidAuthenticityToken

require "json"

class CloudflareProxy
  def initialize(app)
    @app = app
  end

  def call(env)
    return @app.call(env) unless env["HTTP_CF_VISITOR"]

    env["HTTP_X_FORWARDED_PROTO"] = JSON.parse(env["HTTP_CF_VISITOR"])["scheme"]
    @app.call(env)
  end
end

# You will also need to call this in config/application.rb:
#     config.middleware.use CloudflareProxy
