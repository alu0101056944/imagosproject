# Marcos Jesús Barrios Lorenzo

# Check if the context is right for each
# Dont do anything when called inside other's context
# Implement the new methods.

# Compare a radiography to an atlas of radiographies to get the bone age
#
# When out of comparisons context use dsl_atlas and dsl_radiography calls.
# otherwise define own logic on the methods.
class DSLComparison
  def initialize(&block)
    @dsl_atlas = DSLAtlas.new
    @dsl_radiography = DSLRadiography.new
    @atlas = nil
    @radiography = nil

    # radiography level comparisons
    @best_bone_age = nil
    @least_difference = nil

    # bone level comparisons
    @bones_called = []

    @current_context = nil
    @context_flags = {
      atlas_active: false,
      radiography_active: false,
      genre: false,
      age: false,
      comparisons: false,
      compare: false
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

  def comparisons
    raise ArgumentError unless @context_flags[:radiography_active] &&
                               @context_flags[:atlas_active]

    @atlas.reset # to reset comparison checks
    @current_context = 'dsl_comparisons'
    @context_flags[:comparisons] = true
  end

  # Special case: if "atlas :create" then radiography needs to be set earlier
  # than atlas because context won\'t change back unless create is called, which
  # is not necessary if using atlas :create so most likely dsl_atlas will stay
  # on until comparisons, so set the radiography before any atlas call if
  # that specific syntax is used.
  def atlas(*args_array, **args_hash)
    @current_context = 'dsl_atlas' unless !args_array.include?(:create) &&
                                          args_hash[:name]

    @dsl_atlas.atlas(*args_array, **args_hash)
    @atlas = @dsl_atlas.getAtlas
    @context_flags[:genre] = args_hash.include?(:genre)
    @context_flags[:age] = args_hash.include?(:age)
    @context_flags[:atlas_active] = true
  end

  def radiography
    @current_context = 'dsl_radiography' unless @current_context == 'dsl_atlas'
    @radiography = @dsl_atlas.getRadiography unless @current_context == 'dsl_atlas'

    if @current_context == 'dsl_atlas'
      @dsl_atlas.radiography
    else
      @dsl_radiography.radiography
      @radiography = @dsl_radiography.getRadiography
      @context_flags[:radiography_active] = true
    end
  end

  def add
    @dsl_atlas.add if @current_context == 'dsl_atlas'
  end

  def bone(*args_array, **args_hash)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.bone(*args_array, **args_hash)
    elsif @current_context == 'dsl_radiography'
      @dsl_radiography.bone(*args_array, **args_hash)
    end
  end

  def create(*args_array, **args_hash)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.create(*args_array, **args_hash)
      @current_context = nil
    end
  end

  def compare(*args_array, **_)
    raise ArgumentError unless @current_context == 'dsl_comparisons'
    raise ArgumentError unless @context_flags[:age] && @context_flags[:genre]
    raise MissingBoneComparisons if @context_flags[:compare] &&
                                    (args_array.include?(:all) ||
                                    args_array.include?(:radiographies))

    if args_array.include?(:radiographies)
      difference = AtlasRadiography.new(@radiography).differenceScore(
        @atlas.getActiveRadiography
      )
      if @least_difference.nil? || difference < @least_difference
        @least_difference = difference
        @best_bone_age = @atlas.getActiveBoneAge
      end
      @atlas.check # I need show() to do a checkAll() later.
    elsif args_array.include?(:all)
      @best_bone_age = @atlas.getBoneAge(@radiography)
    else
      raise ArgumentError unless !args_array.empty? &&
                                 @radiography.getBoneNames.include?(args_array[0])

      @context_flags[:compare] = true
      @bones_called.push(args_array[0]) unless @bones_called.include?(args_array[0]) # ignore duplicates
    end
  end

  def decide
    raise ArgumentError unless @current_context == 'dsl_comparisons'

    if @context_flags[:compare]
      if (@radiography.getBoneNames - @bones_called).empty?
        difference = AtlasRadiography.new(@radiography).differenceScore(
          @atlas.getActiveRadiography
        )
        if @least_difference.nil? || difference < @least_difference
          @least_difference = difference
          @best_bone_age = @atlas.getActiveBoneAge
        end
        @atlas.check # I need show() to do a checkAll() later.

        @context_flags[:compare] = false
        @bones_called = []
      else
        raise MissingBoneComparisons
      end
    end
  end

  def genre(new_genre)
    raise ArgumentError if @atlas.nil?

    @dsl_atlas.setAtlas(@atlas)
    @dsl_atlas.genre(new_genre)
    @context_flags[:genre] = true
  end

  def age(numeric)
    raise ArgumentError if @atlas.nil?

    @dsl_atlas.setAtlas(@atlas)
    @dsl_atlas.age(numeric)
    @context_flags[:age] = true
  end

  # I do not allow age Increments on the comparisons context because
  # there may not be a radiography with the inserted age after relative
  # adding of active age.
  def ageIncrements(age_increments)
    raise ArgumentError unless @current_context == 'dsl_atlas'

    @dsl_atlas.ageIncrements(age_increments)
  end

  def name(new_name)
    @dsl_atlas.name(new_name) unless @current_context == 'dsl_atlas'
  end

  # Move atlas active age to next age in cronological order
  def continue
    raise ArgumentError unless @current_context == 'dsl_comparisons'

    @atlas.next
  end

  def nextReference
    continue
  end

  def show
    raise ArgumentError unless @current_context == 'dsl_comparisons'
    raise ComparisonsPendingError unless @atlas.checkedAll

    puts("\nResultados:\n")
    puts("Rx carpo y mano izquierda compatible con edad ósea de " +
        "#{@best_bone_age} años.")
    if @best_bone_age > 18
      puts("El informe radiológico establece edad ósea de más de 18 años.")
    elsif @best_bone_age === 18
      puts("El informe radiológico establece edad ósea de 18 años.")
    else
      puts("El informe radiológico establece edad ósea de menos de 18 años.")
    end

    @context_flags[:comparisons] = false
  end

  def setAtlas(new_atlas)
    @context_flags[:atlas_active] = true
    @context_flags[:age] = true
    @context_flags[:genre] = true
    @atlas = new_atlas
  end

  def setRadiography(new_radiography)
    @context_flags[:radiography_active] = true
    @radiography = new_radiography
  end

  private

  def checkFlagBalance
    # error if there is an incomplete comparison going on
    raise ArgumentError if @context_flags[:compare]
    raise ArgumentError if @context_flags[:comparisons]

    raise ComparisonsPendingError if !@atlas.nil? && !@atlas.checkedAll
  end
end
