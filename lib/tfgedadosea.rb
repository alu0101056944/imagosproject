#  Marcos Jesús Barrios Lorenzo

require_relative './tfgedadosea/version.rb'
require_relative './tfgedadosea/bone.rb'
require_relative './tfgedadosea/radiography.rb'
require_relative './tfgedadosea/dsl_radiography.rb'
require_relative './tfgedadosea/atlas.rb'
require_relative './tfgedadosea/dsl_atlas.rb'
require_relative './tfgedadosea/dsl_comparison.rb'
require_relative './tfgedadosea/atlas_radiography.rb'
require_relative './tfgedadosea/error/different_bones_error.rb'
require_relative './tfgedadosea/error/different_measurements_error.rb'
require_relative './tfgedadosea/error/missing_bone_comparisons.rb'
require_relative './tfgedadosea/error/duplicated_radiography_error.rb'
require_relative './tfgedadosea/error/comparisons_pending_error.rb'
require_relative './tfgedadosea/error/missing_bone_categorizations.rb'
require_relative './tfgedadosea/error/out_of_context_error.rb'
require_relative './tfgedadosea/region_of_interest.rb'
require_relative './tfgedadosea/dsl_scoring_system.rb'
require_relative './tfgedadosea/dsl_bone_age.rb'

# Entry point for the gem
module TFGEdadOsea

end
