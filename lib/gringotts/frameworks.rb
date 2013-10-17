# Automatically configure
if defined?(Rails)
  if Rails.const_defined?(:Railtie) # Rails 3
    class Plugin < Rails::Railtie # :nodoc:
      initializer "gringotts.require" do |app|
        require 'gringotts/frameworks/rails'  
        Gringotts::Rails.load!
      end
    end
  else
    Rails.configuration.after_initialize do
      require 'gringotts/frameworks/rails'  
      Gringotts::Rails.load!
    end
  end
end