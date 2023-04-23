# Marcos Jesús Barrios Lorenzo

# Contains a radiography reference for each (age, gender) tuple
class Atlas
  # Justification of nil initialization on class comment
  def initialize(name)
    @name = name
    @radiographies = { male: {}, female: {} }
    @checked_radiographies = { male: {}, female: {} }
    @active_gender = :male
    @active_age = 15
  end

  def setGender(gender)
    raise ArgumentError unless gender.is_a?(Symbol)

    @active_gender = gender
  end

  def setAge(age, relative: false)
    raise ArgumentError unless age.is_a?(Numeric)

    @active_age = relative ? @active_age + age : age
  end

  # set next age as active
  def next
    # the age hash must be sorted for this method to work
    @radiographies[@active_gender] = @radiographies[@active_gender].sort.to_h

    # find current, then step once and update active age
    found_current = false
    @radiographies[@active_gender].each_key do |age|
      if age == @active_age
        found_current = true

        # warn if current is last
        if age == @radiographies[@active_gender].keys.last
          print 'Warning: \'next\' call when already at last atlas radiography.'
        end
        next
      end

      # this is executed after current age has been found
      if found_current
        @active_age = age # set next age as active
        break
      end
    end
  end

  def addRadiography(radiography, age = @active_age, gender = @active_gender)
    raise DuplicatedRadiographyError unless @radiographies[gender][age].nil?

    @radiographies[gender][age] = radiography
    @checked_radiographies[gender][age] = false
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
    @radiographies[@active_gender][@active_age]
  end

  def check
    @checked_radiographies[@active_gender][@active_age] = true
  end

  # keep the false values, if empty then yes, have checked all
  def checkedAll
    @checked_radiographies[@active_gender].values.reject { |flag| flag }.empty?
  end

  # for when I want to reset the checkedAll
  # ideally when a new target radiography is set
  def reset
    @checked_radiographies.each do |_, genre_hash|
      genre_hash.each { |age, _| genre_hash[age] = false }
    end
  end

  attr_writer :name
end
