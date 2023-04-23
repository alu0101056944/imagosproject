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

  # Needed to be able to support "continue" and "nextReference" operations
  # on DSLComparison. Original design did not have this.
  #
  # Set next age as active
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

  # DSLAtlas uses this to create the atlas.
  #
  # Note: The age and gender parameters are used only during spec testing, it is
  # not necessary, but I keep it just in cases I need it.
  def addRadiography(radiography, age = @active_age, gender = @active_gender)
    raise DuplicatedRadiographyError unless @radiographies[gender][age].nil?

    @radiographies[gender][age] = radiography
    @checked_radiographies[gender][age] = false
  end

  # Meant for "compare :all" to get the final bone age of the target radiography
  def getBoneAge(radiography)
    @least_difference = nil
    @best_age = nil
    @radiographies.each do |genre, ages_hash|
      ages_hash.each do |age, rad|
        difference = AtlasRadiography.new(radiography).differenceScore(
          rad
        )

        if @least_difference.nil? || difference < @least_difference
          @least_difference = difference
          @best_age = age
        end

        @checked_radiographies[genre][age] = true
      end
    end
    @best_age
  end

  # Not attr_reader because UML specification for the initial design is like this
  # and I want to keep the changes from the initial design at a minimum.
  def getActiveBoneAge
    @active_age
  end

  def getActiveRadiography
    @radiographies[@active_gender][@active_age]
  end

  # To know if all radiographies have been compared or not in DSLComparison.
  # I call this whenever a "compare :radiographies" takes place.
  def check
    @checked_radiographies[@active_gender][@active_age] = true
  end

  # I call this when show() of DSLComparisons by design decision, since
  # allowing comparison of just a few radiographies would get confusing.
  #
  # Check if there are "false" values on @checked_radiographies.
  def checkedAll
    @checked_radiographies[@active_gender].values.reject { |flag| flag }.empty?
  end

  # When a new comparisons context is called, this is also called to
  # be able to count the amount of checked radiographies again.
  def reset
    @checked_radiographies.each do |_, genre_hash|
      genre_hash.each { |age, _| genre_hash[age] = false }
    end
  end

  attr_writer :name
end
