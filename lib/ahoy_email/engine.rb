require "rails/engine"

module AhoyEmail
  class Engine < ::Rails::Engine
    initializer "ahoy_email" do |app|
      AhoyEmail.secret_token ||= begin
        creds =
          if app.respond_to?(:credentials) && app.credentials.secret_key_base
            app.credentials
          elsif app.respond_to?(:secrets) && (Rails::VERSION::STRING.to_f < 7.1 || app.config.paths["config/secrets"].existent.any?)
            app.secrets
          else
            app.config
          end

        token = creds.respond_to?(:secret_key_base) ? creds.secret_key_base : creds.secret_token
        token ||= app.secret_key_base # should come first, but need to maintain backward compatibility
        token
      end
    end
  end
end
