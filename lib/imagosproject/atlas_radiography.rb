# Marcos Jesús Barrios Lorenzo

require_relative './error/different_measurements_error.rb'
require_relative './error/different_bones_error.rb'

# Contains the algorithm for getting the difference between two radiographies.
#
# This is used on DSLComparison on the compare method to calculate the difference
# and update the best difference if it proceeds.
class AtlasRadiography
  def initialize(radiography)
    @radiography = radiography
  end

  # calculate difference between two radiographies
  def differenceScore(other_radiography)
    difference = 0
    own_bone_names = @radiography.getBoneNames
    other_bone_names = other_radiography.getBoneNames
    raise DifferentBonesError unless
        (other_bone_names - own_bone_names).empty? &&
        (own_bone_names - other_bone_names).empty?
    own_bone_names.each do |name|
      other = other_radiography.getMeasurements(name)
      own = @radiography.getMeasurements(name)
      raise DifferentMeasurementsError unless (other.keys - own.keys).empty? &&
                                              (own.keys - other.keys).empty?

      own.each_key { |k| difference += (own[k] - other[k]).abs }
    end
    difference
  end

  # calculate difference between two bones
  def difference(bone_name, other_radiography)
    other = other_radiography.getMeasurements(bone_name)
    own = @radiography.getMeasurements(bone_name)
    raise DifferentBonesError if other.nil? || own.nil?
    raise DifferentMeasurementsError unless (other.keys - own.keys).empty? &&
                                            (own.keys - other.keys).empty?

    difference = 0
    own.each_key { |k| difference += (own[k] - other[k]).abs if other[k] }
    difference
  end
end
