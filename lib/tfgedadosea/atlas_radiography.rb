# Marcos Jesús Barrios Lorenzo

# Contains the algorithm for getting the difference between two radiographies.
class AtlasRadiography
  def initialize(radiography)
    @radiography = radiography
  end

  def differenceScore(other_radiography)
    difference = 0
    @radiography.getBoneNames.each do |name|
      other = other_radiography.getMeasurements(name)
      this = @radiography.getMeasurements(name)
      raise DifferentBonesError if other.nil? || this.nil?
      raise DifferentMeasurementErrors unless (other.keys - this.keys).empty?

      this.each_key { |k| difference += (this[k] - other[k]).abs if other[k] }
    end
    difference
  end

  def difference(bone_name, other_radiography)
    other = other_radiography.getMeasurements(bone_name)
    this = @radiography.getMeasurements(bone_name)
    raise DifferentBonesError if other.nil? || this.nil?
    raise DifferentMeasurementsError unless (other.keys - this.keys).empty?

    difference = 0
    this.each_key { |k| difference += (this[k] - other[k]).abs if other[k] }
    difference
  end
end
