# frozen_string_literal: true

require_relative 'lib/tfgedadosea/version'

Gem::Specification.new do |spec|
  spec.name          = 'tfgedadosea'
  spec.version       = TFGEdadOsea::VERSION
  spec.authors       = ['Marcos Jesús Barrios Lorenzo']
  spec.email         = ['alu0101056944@ull.edu.es']

  spec.summary       = 'Bone age estimation Domain-Specific Language'
  spec.description   = 'A radiography is observed and measurements are explicitly written in a script for this program to do the comparisons'
  spec.homepage      = 'https://github.com/ULL-ESIT-LPP-2122/granja-alu0101056944.git'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ULL-ESIT-LPP-2122/granja-alu0101056944.git'
  spec.metadata['changelog_uri'] = 'https://github.com/ULL-ESIT-LPP-2122/granja-alu0101056944.git'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'thor', '~> 1.2.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
