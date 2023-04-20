# Marcos Jesús Barrios Lorenzo

# Contains a radiography reference for each (age, gender) tuple
#
# I decided that setGender() and setAge() must be called before usage.
class Atlas
  # Justification of nil initialization on class comment
  def initialize(name)
    raise ArgumentError unless name.is_a?(Symbol)

    @name = name
    @radiographies = { male: {}, female: {} }
    @active_gender = :male
    @active_age = 15
    @active_radiography = nil
  end

  def setGender(gender)
    raise ArgumentError unless gender.is_a?(Symbol)

    @active_gender = gender
    @active_radiography = @radiographies[@active_gender][@active_age]
  end

  def setAge(age)
    raise ArgumentError unless age.is_a?(Numeric)

    @active_age = age
    @active_radiography = @radiographies[@active_gender][@active_age]
  end

  def addRadiography(radiography, age, gender)
    raise ArgumentError unless radiography.is_a?(Radiography) &&
                               age.is_a?(Numeric) &&
                               gender.is_a?(Symbol)

    @radiographies[gender][age] = radiography
  end

  def getBoneAge(radiography)
    names = radiography.getBoneNames
    measurements = radiography.getMeasurements

    @radiographies.each_value do |ages_hash|
      ages_hash.each do |age, rad|
        return age if rad.names == names && rad.measurements == measurements
      end
    end
  end

  # Not attr_reader because UML specification for the initial design is like this
  # and I want to keep the changes from the initial design at a minimum.
  def getActiveBoneAge
    @active_age
  end

  def getActiveRadiography
    @active_radiography
  end
end
