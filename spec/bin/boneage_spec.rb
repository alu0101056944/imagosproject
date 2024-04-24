
require 'securerandom'
require 'psych'

RSpec.describe 'Testing boneage executable' do
  describe 'Invalid file path testing.' do
    it 'Executes the program if file exists.' do
      begin
        simple_example_file_content = %Q[
          ImagosProject do
            radiography name: 'Antonio'
            bone :radius, length: 21
            bone :ulna, length: 20
  
            atlas :create, name: :atlas_generated_for_dsl_comparison_spec
            genre :male
            age 8
  
            radiography
            bone :ulna, length: 21
            bone :radius, length: 20
            ageIncrements 1
  
            radiography
            bone :ulna, length: 22
            bone :radius, :relative, :ulna, length: -2
  
            comparisons
            compare :all
            show
          end
        ]
        random_new_file_path = './' + SecureRandom.hex(10) +
            '_unittest_generated.txt'
        while File.exist?(random_new_file_path)
          random_new_file_path = SecureRandom.hex(10) + '.txt'
        end
        File.write(random_new_file_path, simple_example_file_content)

        output = `#{ImagosProject.config['executable_path']} execute #{random_new_file_path}`
        expect(output).to match(/Executing.*file/i)
      ensure
        if File.exist?(random_new_file_path)
          File.delete(random_new_file_path)
        end
      end
    end

    it 'Stops execution if file does not exist.' do
      random_non_existant_path = SecureRandom.hex(10) + '.txt'
      while File.exist?(random_non_existant_path)
        random_non_existant_path = SecureRandom.hex(10) + '.txt'
      end

      output = `#{ImagosProject.config['executable_path']} execute #{random_non_existant_path}`
      expect(output).to include('LoadError')
    end
  end

  describe 'Logging levels testing.' do
    it 'Level two outputs backtrace' do
      begin
        random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        while File.exist?(random_non_existant_path)
          random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        end

        random_non_existant_path_config = SecureRandom.hex(10) + '.temp.txt'
        while File.exist?(random_non_existant_path_config)
          random_non_existant_path_config = SecureRandom.hex(10) + '.temp.txt'
        end
        config_extra_logging = %Q[
          executable_path: #{ImagosProject.config['executable_path']}
          logging_level: 2
        ]
        File.write(random_non_existant_path_config, config_extra_logging)
        output = `#{ImagosProject.config['executable_path']} execute #{random_non_existant_path} \
            -c #{random_non_existant_path_config}`
        expect(output).to match(/.+:\d+:in/)
      ensure
        if File.exist?(random_non_existant_path_config)
          File.delete(random_non_existant_path_config)
        end
      end
    end

    it 'Level one does not output backtrace' do
      begin
        random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        while File.exist?(random_non_existant_path)
          random_non_existant_path = SecureRandom.hex(10) + '.temp.txt'
        end

        random_non_existant_path_config = SecureRandom.hex(10) + '.temp.txt'
        while File.exist?(random_non_existant_path_config)
          random_non_existant_path_config = SecureRandom.hex(10) + '.temp.txt'
        end
        config_extra_logging = %Q[
          executable_path: #{ImagosProject.config['executable_path']}
          logging_level: 1
        ]
        File.write(random_non_existant_path_config, config_extra_logging)
        output = `#{ImagosProject.config['executable_path']} execute #{random_non_existant_path} \
            -c #{random_non_existant_path_config}`
        expect(output).not_to match(/.+:\d+:in/)
      ensure
        if File.exist?(random_non_existant_path_config)
          File.delete(random_non_existant_path_config)
        end
      end
    end
  end
end
