# Marcos Jesús Barrios Lorenzo

# Four different context related to bone age estimation:
# radiography, atlas, comparisons, scoringSystem.
# integration of those four dsl into one.
class DSLBoneAge
  def initialize(&block)
    @dsl_atlas = DSLAtlas.new
    @dsl_radiography = DSLRadiography.new
    @dsl_comparisons = DSLComparison.new
    @dsl_scoring_system = DSLScoringSystem.new

    @current_context = nil

    if block_given?
      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end
  end

  # Context change method
  def radiography(*args_array, **args_hash)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.radiography
    else
      @current_context = 'dsl_radiography'
      @dsl_radiography.radiography(*args_array, **args_hash)
      @radiography = @dsl_radiography.getRadiography
      @dsl_comparisons.setRadiography(@radiography)
    end
  end

  def bone(*args_array, **args_hash)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.bone(*args_array, **args_hash)
    elsif @current_context == 'dsl_radiography'
      @dsl_radiography.bone(*args_array, **args_hash)
    else
      raise OutOfContextError
    end
  end

  # Context change method
  def atlas(*args_array, **args_hash)
    @current_context = 'dsl_atlas'
    @dsl_atlas.atlas(*args_array, **args_hash)
    @atlas = @dsl_atlas.getAtlas
    @dsl_comparisons.setAtlas(@atlas)
  end

  def add
    if @current_context == 'dsl_atlas'
      @dsl_atlas.add
    else
      raise OutOfContextError
    end
  end

  # Context change method
  def create(*args_array, **args_hash)
    if @current_context == 'dsl_atlas'
      @current_context = nil
      dsl_atlas.create(*args_array, **args_hash)
    else
      raise OutOfContextError
    end
  end

  def genre(new_genre)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.genre(new_genre)
    elsif @current_context == 'dsl_comparisons'
      @dsl_comparisons.genre(new_genre)
    else
      raise OutOfContextError
    end
  end

  def age(new_age)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.age(new_age)
    elsif @current_context == 'dsl_comparisons'
      @dsl_comparisons.age(new_age)
    else
      raise OutOfContextError
    end
  end

  def ageIncrements(new_age_increments)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.ageIncrements(new_age_increments)
    else
      raise OutOfContextError
    end
  end

  def name(new_name)
    if @current_context == 'dsl_atlas'
      @dsl_atlas.name(new_name)
    else
      raise OutOfContextError
    end
  end

  # Context change method
  def comparisons
    @current_context = 'dsl_comparisons'
    @dsl_comparisons.comparisons
    @dsl_comparisons.setAtlas(@atlas)
    @dsl_comparisons.setRadiography(@radiography)
  end

  def compare(*args_array, **args_hash)
    if @current_context == 'dsl_comparisons'
      @dsl_comparisons.compare(*args_array, **args_hash)
    else
      raise OutOfContextError
    end
  end

  def continue
    if @current_context == 'dsl_comparisons'
      @dsl_comparisons.continue
    else
      raise OutOfContextError
    end
  end

  def decide
    if @current_context == 'dsl_comparisons'
      @dsl_comparisons.decide
    else
      raise OutOfContextError
    end
  end

  def nextReference
    continue
  end

  def mean
    if @current_context == 'dsl_scoring_system'
      @dsl_scoring_system.mean
    else
      raise OutOfContextError
    end
  end

  def sum
    if @current_context == 'dsl_scoring_system'
      @dsl_scoring_system.sum
    else
      raise OutOfContextError
    end
  end

  # Context change method
  def show(*args_array, **args_hash)
    if @current_context == 'dsl_comparisons'
      @current_context = nil
      @dsl_comparisons.show(*args_hash, **args_hash)
    elsif @current_context == 'dsl_scoring_system'
      @current_context = nil
      @dsl_scoring_system.show(*args_hash, **args_hash)
    else
      raise OutOfContextError
    end
  end

  # Context change method
  def scoringSystem
    @current_context = 'dsl_scoring_system'
    @dsl_scoring_system.setRadiography(@radiography)
    @dsl_scoring_system.scoringSystem
  end

  def roi(*args_array, **args_hash)
    if @current_context == 'dsl_scoring_system'
      @dsl_scoring_system.roi(*args_array, **args_hash)
    else
      raise OutOfContextError
    end
  end
end
