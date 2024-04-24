
RSpec.describe 'ImagosProject module testing.' do
  describe 'Configuration load testing.' do
    it 'Default configuration file is correctly written as user config.' do
      random_non_existant_path_default = SecureRandom.hex(10) + '.temp.txt'
      while File.exist?(random_non_existant_path_default)
        random_non_existant_path_default = SecureRandom.hex(10) + '.temp.txt'
      end

      begin
        random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        while File.exist?(random_non_existant_path)
          random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        end

        default_config_content = %Q[
          # This file is menat to have the contents that will be used when the user
          # configured ./config.yml is missing

          # DO NOT CHANGE

          executable_path: '#{ImagosProject.config['executable_path']}'
          logging_level: 1
        ]
        File.write(random_non_existant_path_default, default_config_content)

        ImagosProject.loadConfig(random_non_existant_path,
            random_non_existant_path_default)
        config = ImagosProject.config
        default_config = Psych.safe_load(File.read(random_non_existant_path_default))
        expect(config).to eq(default_config)
      ensure
        if File.exist?(random_non_existant_path_default)
          File.delete(random_non_existant_path_default)
        end
        if File.exist?(random_non_existant_path)
          File.delete(random_non_existant_path)
        end
      end
    end

    it 'User config directory method points to existing file' do
      expect(File.exist?(ImagosProject.userConfigDir())).to be(true)
    end

    it 'Default config directory method points to existing file' do
      expect(File.exist?(ImagosProject.defaultConfigDir())).to be(true)
    end
  end
end
