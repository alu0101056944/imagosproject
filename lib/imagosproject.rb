#  Marcos Jesús Barrios Lorenzo

require('psych')

require_relative './imagosproject/version.rb'
require_relative './imagosproject/bone.rb'
require_relative './imagosproject/radiography.rb'
require_relative './imagosproject/dsl_radiography.rb'
require_relative './imagosproject/atlas.rb'
require_relative './imagosproject/dsl_atlas.rb'
require_relative './imagosproject/dsl_comparison.rb'
require_relative './imagosproject/atlas_radiography.rb'

require_relative './imagosproject/error/different_bones_error.rb'
require_relative './imagosproject/error/different_measurements_error.rb'
require_relative './imagosproject/error/missing_bone_comparisons.rb'
require_relative './imagosproject/error/duplicated_radiography_error.rb'
require_relative './imagosproject/error/comparisons_pending_error.rb'
require_relative './imagosproject/error/missing_bone_categorizations.rb'
require_relative './imagosproject/error/out_of_context_error.rb'
require_relative './imagosproject/error/missing_config_key_error.rb'

require_relative './imagosproject/region_of_interest.rb'
require_relative './imagosproject/dsl_scoring_system.rb'
require_relative './imagosproject/dsl_bone_age.rb'

# Entry point for the gem
module ImagosProject
  class << self
    # Call loadConfig() first
    attr_reader :config

    # Any executable should call this on initial steps
    # the parameter is for the RSpec specs for avoiding writing to the same file
    # and thus avoiding race conditions. assumming that they are ran async and
    # many specs reading/writing to the same file will causes racing conditions.
    # Same for default config dir.
    def loadConfig(user_config_path = userConfigDir(),
        default_config_path = defaultConfigDir())

      unless File.exist?(user_config_path)
        if File.exist?(default_config_path)
          File.write(user_config_path, File.read(default_config_path))
        end
      end

      begin
        config = Psych.safe_load(File.read(user_config_path))
        default_config = Psych.safe_load(File.read(default_config_path))
        default_keys_found = default_config
            .keys
            .filter { |default_key| config.keys.include?(default_key) }
        unless (default_config.keys - default_keys_found).empty?
          raise MissingConfigKeyError
        end
        @config = config
      rescue Exception => e
        puts 'ERROR when loading the user config file. Using default config' +
            " instead.\n#{e.message}"
        @config = Psych.safe_load(File.read(default_config_path))
      end
    end  

    def userConfigDir
      return File.expand_path('../../config.yml', __FILE__)
    end

    def defaultConfigDir
      return File.expand_path('../imagosproject/default_config.yml', __FILE__)
    end
  end
end
