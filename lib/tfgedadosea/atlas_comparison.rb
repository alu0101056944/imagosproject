# Marcos Jesús Barrios Lorenzo

# More verbally accumulate differences. Meant for DSLComparison.
class AtlasComparison
  def initialize
    @total_difference = 0
  end

  def addDifference(number)
    raise ArgumentError if number.negative?

    @total_difference += number
  end

  def getTotalDifference
    @total_difference
  end
end
