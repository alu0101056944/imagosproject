=begin
  Marcos Jesús Barrios Lorenzo
=end

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

  def instanceFromNonIntrinsic(relativeMeasurements)
    measurementsArray = @measurements.map do |k, v|
                            newMeasurement = v
                            newMeasurement += relativeMeasurements[k] if relativeMeasurements[k]
                            raise ArgumentError if newMeasurement < 0
                            [k, newMeasurement]
                          end
    measurementsHash = measurementsArray.to_h
    name = relativeMeasurements["name"] ? relativeMeasurements["name"] : @name
    return Bone.new(name, measurementsHash)
  end

  def <=>(boneName)
    return @name == boneName ? 0 : -1
  end

  attr_reader :measurements
  attr_reader :name
end
