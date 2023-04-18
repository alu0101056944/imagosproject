# Marcos Jesús Barrios Lorenzo

class Bone
  include Comparable

  def initialize(name, measurements)
    @name = name
    @measurements = measurements
    measurements.each { |k, v| raise ArgumentError if v <= 0 }
  end

  def distanceFrom(other)
    intersection = @measurements.keys.select { |k| other.measurements[k] }
    intersection.reduce(0) { |acc, k| acc + (@measurements[k] - other.measurements[k]).abs }
  end

  def instanceFromNonIntrinsic(new_name, relative_measurements)
    new_measurements_array = @measurements.map do |k, v|
                            new_measurement = v
                            new_measurement += relative_measurements[k] if relative_measurements[k]
                            raise ArgumentError if new_measurement < 0
                            [k, new_measurement]
                          end
    measurements_hash = new_measurements_array.to_h
    name = relative_measurements["name"] ? relative_measurements["name"] : @name
    return Bone.new(new_name, measurements_hash)
  end

  def <=>(boneName)
    return @name == boneName ? 0 : -1
  end

  attr_reader :measurements
  attr_reader :name
end
