# Marcos Jesús Barrios Lorenzo

# Contains the algorithm for getting the difference between two radiographies.
#
# This is used on DSLComparison on the compare method to calculate the difference
# and update the best difference if it proceeds.
class AtlasRadiography
  def initialize(radiography)
    @radiography = radiography
  end

  # calculate full difference between two radiographies
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

  # calculate difference between two bones
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
