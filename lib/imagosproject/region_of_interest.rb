# Represents a region of interest of the tanner whitehouse method.
class RegionOfInterest
  def initialize(description, bone_names)
    @description = description
    @bone_names = bone_names
    @score = 0
  end

  def setScore(score)
    @score = score
  end

  def getScore
    @score
  end
end
