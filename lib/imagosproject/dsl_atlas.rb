# Marcos Jesús Barrios Lorenzo

# I decided that setGender() and setAge() must be called before adding
# any radiography, because the radiography is categorized as (gender, age).
#
# Atlas load:
# With "atlas name:<atlas name here>""
#
# Atlas creation:
# With "atlas (...) create atlas:<atlas name here>"
# With "atlas (...) name: <atlas name here> (...) create"
# With "atlas :create name:<atlas name here>""
#
# To keep track of which methods have been called I use flags.
# There are flags for each possible method callinside  the dsl.
# When a method is called, it must check if it was called in the right
# context. Before exit it must leave the right flags on.
#
class DSLAtlas
  def initialize(&block)
    @atlas = nil
    @created_radiography = nil
    @age_increments = 1

    # flags for controlling whenever a method is called
    # flags for start-end (like atlas, create) and flags for "must call" (like genre, etc)
    @context_flags = {
      atlas: false,
      create: false,
      radiography: false,
      add: false,
      name: false,
      genre: false, # radiography requires genre and age to be selected
      age: false    # so that the atlas knows where to store the radiography
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

  # load atlas or create atlas.
  # Also set active age and genre if those flags were passed as parameter.
  def atlas(*args_array, **args_hash)
    raise ArgumentError if @context_flags[:atlas] # Because I dont want "atlas()atlas()" calls

    if !args_array.include?(:create) && args_hash[:name]
      loadAtlas(args_hash[:name])
    else
      @atlas = Atlas.new(args_hash[:name])

      @context_flags[:create] = args_array.include?(:create)
      @context_flags[:atlas] = true

      if args_hash[:name]
        @atlas.name = args_hash[:name]
        @context_flags[:name] = true
      end
    end

    if args_hash[:age]
      @atlas.setAge(args_hash[:age])
      @context_flags[:age] = true
    end
    if args_hash[:genre]
      @atlas.setGender(args_hash[:genre])
      @context_flags[:genre] = true
    end
  end

  # must have an atlas active, and genre and age specified
  def radiography(*_, **args_hash)
    raise ArgumentError unless @context_flags[:atlas] &&
                               @context_flags[:genre] &&
                               @context_flags[:age]

    @created_radiography = Radiography.new
    @created_radiography.observer_name = args_hash[:name]
    @atlas.setAge(@age_increments, relative: true)
    @atlas.addRadiography(@created_radiography)

    @context_flags[:add] = false
    @context_flags[:radiography] = true
  end

  # Ends radiography flag. Can only be called once after radiography
  def add
    raise ArgumentError unless @context_flags[:radiography]

    @context_flags[:add] = true
    @context_flags[:radiography] = false
  end

  # must be called while radiograhy is on
  def bone(*args_array, **hash_metrics)
    raise ArgumentError unless @context_flags[:radiography]

    case args_array.length
    when 1 then @created_radiography.addBone(args_array[0], nil, hash_metrics)
    when 3 then @created_radiography.addBone(args_array[2], args_array[0], hash_metrics)
    else raise ArgumentError
    end
  end

  def create(*_, **args_hash)
    raise ArgumentError if @context_flags[:create]
    raise ArgumentError unless @context_flags[:name] &&
                               @context_flags[:atlas] ||
                               args_hash[:atlas] &&
                               @context_flags[:atlas]

    @context_flags[:create] = true
    @context_flags[:atlas] = false
    @context_flags[:genre] = false
    @context_flags[:age] = false
    @context_flags[:name] = false
  end

  def genre(new_genre)
    raise ArgumentError if @atlas.nil?

    @atlas.setGender(new_genre)

    @context_flags[:genre] = true
  end

  def age(numeric)
    raise ArgumentError if @atlas.nil?

    @atlas.setAge(numeric)
    @age_increments = 0

    @context_flags[:age] = true
  end

  def ageIncrements(age_increments)
    raise ArgumentError if @atlas.nil?

    @age_increments = age_increments
  end

  def name(new_name)
    raise ArgumentError if @atlas.nil?

    @atlas.name = new_name

    @context_flags[:name] = true
  end

  def getAtlas
    @atlas
  end

  def setAtlas(atlas)
    @atlas = atlas
  end

  def getRadiography
    @created_radiography
  end

  private

  # May have security risks
  def loadAtlas(name)
    file_content = File.read("atlas/#{name}.rb")
    file_content_dump = Marshal.dump(file_content)
    dsl_atlas_string = Marshal.load(file_content_dump)
    foo = nil
    binding.eval("foo = #{dsl_atlas_string}")
    @atlas = foo.getAtlas
  end

  def checkFlagBalance
    raise ArgumentError if @context_flags[:atlas] && !@context_flags[:create]
  end
end
