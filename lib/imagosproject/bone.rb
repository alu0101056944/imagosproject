# Marcos Jesús Barrios Lorenzo

# Smallest comparison unit of the program.
# I added an observer_name feature so that the "radiography" command
# can get a "name: Marcos" hash key-value.
class Bone
  include Comparable

  def initialize(name, measurements)
    @name = name
    @measurements = measurements
    measurements.each { |_, v| raise ArgumentError if v <= 0 }
    @observer_name = nil
  end

  # Ignore measurement if it's name is not a measurement too in the other bone.
  # thats why I calculate the intersection and then the sum.
  #
  # I enforce equal measurements at DSL level anyways, but I have no time to
  # change this.
  def distanceFrom(other)
    intersection = @measurements.keys.select { |k| other.measurements[k] }
    intersection.reduce(0) { |acc, k| acc + (@measurements[k] - other.measurements[k]).abs }
  end

  # To create a bone from another bone using relative measurements.
  def instanceFromNonIntrinsic(new_name, relative_measurements)
    # The intersection of the measurements gets processed, while the different
    # measurements stay as they are.
    new_measurements_array = @measurements.map do |k, v|
      new_measurement = v
      new_measurement += relative_measurements[k] if relative_measurements[k]
      raise ArgumentError if new_measurement.negative?

      [k, new_measurement] # format that allows to_h to convert to hash
    end
    measurements_hash = new_measurements_array.to_h
    Bone.new(new_name, measurements_hash)
  end

  # For demonstration of Comparable knowledge, instead of getter, use <=>
  # with the name to know if a bone is equal to another.
  def <=>(other)
    @name == other ? 0 : -1
  end

  attr_reader :measurements, :name
  attr_accessor :observer_name
end
