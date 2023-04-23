# Marcos Jesús Barrios Lorenzo

# For tanner-whitehouse comparison.
class DSLScoringSystem
  def initialize(&block)
    @dsl_radiography = DSLRadiography.new
    @radiography = nil
    @bone_age = nil
    @roi_array = []
    # categorized bones
    @bones_categorized = []

    @current_context = nil
    @context_flags = {
      radiography_active: false,
      scoringSystem: false
    }

    if block_given?
      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end

    checkFlagBalance
  end

  def scoringSystem
    raise ArgumentError if @context_flags[:scoringSystem]
    raise ArgumentError unless @context_flags[:radiography_active]

    @current_context = 'dslScoringSystem'
    @context_flags[:scoringSystem] = true
  end

  def roi(*args_array, **args_hash)
    raise ArgumentError unless @current_context == 'dslScoringSystem'
    raise ArgumentError if args_array.length < 2 ||
                           !args_array.first.is_a?(String) ||
                           !args_hash[:score]

    roi_bone_names = []
    new_roi = RegionOfInterest.new(args_array.first, roi_bone_names)
    new_roi.setScore(args_hash[:score])

    # add bone names to roi and to bones categorized array
    args_array.drop(1).each do |bone_name|
      roi_bone_names.push(bone_name)
      @bones_categorized.push(bone_name)
    end

    @roi_array.push(new_roi)
  end

  def sum
    raise ArgumentError unless @current_context == 'dslScoringSystem'
    raise MissingBoneCategorizations unless (@radiography.getBoneNames - @bones_categorized).empty?

    @bone_age = @roi_array.reduce(0) { |acc, roi| acc + roi.getScore }
  end

  def mean
    raise ArgumentError unless @current_context == 'dslScoringSystem'
    raise MissingBoneCategorizations unless (@radiography.getBoneNames - @bones_categorized).empty?

    # mean = numerator / amount of rois
    numerator = @roi_array.reduce(0) { |acc, roi| acc + roi.getScore }
    @bone_age = numerator / @roi_array.length
  end

  def show
    raise ArgumentError unless @current_context == 'dslScoringSystem'

    puts "Bone age by scoring system: #{@bone_age}"
    @current_context = nil
    @context_flags[:scoringSystem] = false
  end

  def radiography
    @current_context = 'dsl_radiography'
    @context_flags[:radiography_active] = true
    @dsl_radiography.radiography
    @radiography = @dsl_radiography.getRadiography
  end

  def bone(*args_array, **args_hash)
    raise ArgumentError unless @current_context == 'dsl_radiography'

    @dsl_radiography.bone(*args_array, **args_hash)
  end

  def setRadiography(radiography)
    @radiography = radiography
    @context_flags[:radiography_active] = true
  end

  private

  def checkFlagBalance
    raise ArgumentError if @context_flags[:scoringSystem]
  end
end
