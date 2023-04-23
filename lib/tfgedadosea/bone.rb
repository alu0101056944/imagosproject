# Marcos Jesús Barrios Lorenzo

# Smallest comparison unit of the program.
class Bone
  include Comparable

  def initialize(name, measurements)
    @name = name
    @measurements = measurements
    measurements.each { |_, v| raise ArgumentError if v <= 0 }
    @observer_name = nil
  end

  def distanceFrom(other)
    intersection = @measurements.keys.select { |k| other.measurements[k] }
    intersection.reduce(0) { |acc, k| acc + (@measurements[k] - other.measurements[k]).abs }
  end

  def instanceFromNonIntrinsic(new_name, relative_measurements)
    new_measurements_array = @measurements.map do |k, v|
      new_measurement = v
      new_measurement += relative_measurements[k] if relative_measurements[k]
      raise ArgumentError if new_measurement.negative?

      [k, new_measurement]
    end
    measurements_hash = new_measurements_array.to_h
    Bone.new(new_name, measurements_hash)
  end

  def <=>(other)
    @name == other ? 0 : -1
  end

  attr_reader :measurements, :name
  attr_accessor :observer_name
end
