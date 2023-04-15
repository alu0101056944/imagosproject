=begin
  Marcos Jesús Barrios Lorenzo
=end

class Radiography
  def initialize()
    @bones = []
  end

  def addBone(name, intrinsic, measurements)
    @bones.push(Bone.new(name, measurements))
    return true;
  end

  def hasBone(name)
    (@bones.select { |bone| bone == name }).length > 0
  end

  def getMeasurements(name)
    (@bones.select { |bone| bone.name == name }).first.measurements
  end

  def getBoneNames()
    @bones.map { |bone| bone.name }
  end
end
