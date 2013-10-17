# adapted from https://github.com/assaf/vanity/
module Gringotts

  # Config holds the Gringotts configuration.
  class Config
    
    attr_accessor :endpoint, :api_version, :account, :secret    
    
    DEFAULTS = { 
      :endpoint => nil,
      :api_version => 0,
      :account => nil,
      :secret => nil
    }
    
    ROUTE_VERIFY = '/authentication/verify'
    
    def initialize(filename = "gringotts.yml")          
      begin
        if config_file_exists?
          config = load_config_file(filename)[Gringotts::Config.env]
          if Hash === config
            config = config.inject({}) { |h,kv| h[kv.first.to_sym] = kv.last ; h }
          else
            raise "Config file (#{config_file_root}/#{filename}) is either not correct YAML or is lacking environment [#{Gringotts::Config.env}]. Aborting."
          end
        end
      rescue Errno::ENOENT => e
        raise "Config file (#{config_file_root}/#{filename}) does not exist. Aborting."
      end

      options = DEFAULTS#.merge(config)

      @endpoint    = options[:endpoint]
      @api_version = options[:api_version]
      @account     = options[:account]
      @secret      = options[:secret]
    end
    
    def config_file_root
      (defined?(::Rails) ? ::Rails.root : Pathname.new(".")) + "config"
    end

    def config_file_exists?(basename = "gringotts.yml")
      File.exists?(config_file_root + basename)
    end

    def load_config_file(basename = "gringotts.yml")
      YAML.load(ERB.new(File.read(config_file_root + basename)).result)
    end
    
    # needs to be static because otherwise we try to read the gringotts.yml config file ! !!!
    def self.env
      return ENV["RACK_ENV"] || ENV["RAILS_ENV"] || "development"
    end
    
  end # Config
  
end # Gringotts