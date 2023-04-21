# Marcos Jesús Barrios Lorenzo

# I decided that setGender() and setAge() must be called before usage.
#
# Atlas load:
# With atlas name:<atlas name here>
#
# Atlas creation:
# With atlas (...) create atlas:<atlas name here>
# With atlas (...) name: <atlas name here> (...) create
# With atlas :create name:<atlas name here>
#
# To keep the context, there are flags for each possible type of context inside
# the dsl. When a method is called, it must check if it was called in the right
# context. Before exit, it must leave the right flags on.
#
class DSLAtlas
  def initialize(&block)
    @atlas = nil
    @created_radiography = nil
    @age_increments = 1
    @context_flags = {
      atlas: false,
      create: false,
      radiography: false,
      add: false,
      name: false,
      genre: false,
      age: false
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

  def atlas(*args_array, **args_hash)
    raise ArgumentError if @context_flags[:atlas]

    if !args_array.include?(:create) && args_hash[:name]
      loadAtlas(args_hash[:name])
    else
      @atlas = Atlas.new(args_hash[:name])

      @context_flags[:atlas] = true
      @context_flags[:create] = args_array.include?(:create)

      if args_hash[:name]
        @atlas.name = args_hash[:name]
        @context_flags[:name] = true
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
  end

  def radiography(*_, **_)
    raise ArgumentError unless @context_flags[:atlas] &&
                               @context_flags[:genre] &&
                               @context_flags[:age]

    @created_radiography = Radiography.new
    @atlas.setAge(@age_increments, relative: true)
    @atlas.addRadiography(@created_radiography)

    @context_flags[:add] = false
    @context_flags[:radiography] = true
  end

  def add
    raise ArgumentError unless @context_flags[:radiography]

    @context_flags[:add] = true
    @context_flags[:radiography] = false
  end

  # args_array must be either [name] or [name, isRelative, referenceName]
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

  def age(numeric)
    raise ArgumentError unless @context_flags[:atlas]

    @atlas.setAge(numeric)
    @age_increments = 0

    @context_flags[:age] = true
  end

  def genre(new_genre)
    raise ArgumentError unless @context_flags[:atlas]

    @atlas.setGender(new_genre)

    @context_flags[:genre] = true
  end

  def ageIncrements(age_increments)
    raise ArgumentError unless @context_flags[:atlas]

    @age_increments = age_increments
  end

  def name(new_name)
    raise ArgumentError unless @context_flags[:atlas]

    @atlas.name = new_name

    @context_flags[:name] = true
  end

  def getAtlas
    @atlas
  end

  private

  # May have security risks
  def loadAtlas(name)
    file_content = File.read("atlas/#{name}.rb")
    file_content_dump = Marshal.dump(file_content)
    dsl_atlas_string = Marshal.load(file_content_dump)
    dsl_atlas = nil
    eval("dsl_atlas = #{dsl_atlas_string}")
    @atlas = dsl_atlas.getAtlas
  end

  def checkFlagBalance
    raise ArgumentError if @context_flags[:atlas] && !@context_flags[:create]
  end
end
