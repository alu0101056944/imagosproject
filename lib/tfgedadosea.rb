#  Marcos Jesús Barrios Lorenzo

require_relative 'tfgedadosea/version'
require_relative 'tfgedadosea/bone'
require_relative 'tfgedadosea/radiography'
require_relative 'tfgedadosea/dsl_radiography'
require_relative 'tfgedadosea/atlas'
require_relative 'tfgedadosea/dsl_atlas'
require_relative 'tfgedadosea/dsl_comparison'
require_relative 'tfgedadosea/atlas_comparison'
require_relative 'tfgedadosea/atlas_radiography'
require_relative 'tfgedadosea/error/different_bones_error'
require_relative 'tfgedadosea/error/different_measurements_error'
require_relative 'tfgedadosea/error/missing_bone_comparisons'
require_relative 'tfgedadosea/error/duplicated_radiography_error'
require_relative 'tfgedadosea/error/comparisons_pending_error'
require_relative 'tfgedadosea/error/missing_bone_categorizations'
require_relative 'tfgedadosea/error/out_of_context_error'
require_relative 'tfgedadosea/region_of_interest'
require_relative 'tfgedadosea/dsl_scoring_system'
require_relative 'tfgedadosea/dsl_bone_age'

# Entry point for the gem
module TFGEdadOsea

end
