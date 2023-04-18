# Marcos Jesús Barrios Lorenzo

# Creates bones from measurements and includes them into the radiography
class DSLRadiography
  def initialize(&block)
    @radiography = Radiography.new
    if block_given?
      if block.arity == 1
        yield self
      else
        instance_eval(&block)
      end
    end
  end

  def radiography; end

  # args_array must be either [name] or [name, isRelative, referenceName]
  def bone(*args_array, **hash_measurements)
    if args_array.empty? || hash_measurements.empty? ||
       !args_array.reject { |e| e.is_a?(Symbol) }.empty? ||
       !hash_measurements.keys.reject { |e| e.is_a?(Symbol) }.empty? ||
       !hash_measurements.values.reject { |e| e.is_a?(Numeric) }.empty?
      raise ArgumentError
    end

    case args_array.length
    when 0 then raise ArgumentError
    when 1 then @radiography.addBone(args_array[0], nil, hash_measurements)
    when 2 then raise ArgumentError
    when 3..args_array.length then @radiography.addBone(args_array[2], args_array[0], hash_measurements)
    end
  end

  def getRadiography
    @radiography
  end
end
