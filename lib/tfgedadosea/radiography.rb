# Marcos Jesús Barrios Lorenzo

class Radiography
  def initialize
    @bones = []
  end

  # if new_name is nil then instance from scratch. Otherwise it is
  # non intrinsic instancing.
  def addBone(name, new_name, measurements)
    bone_search = @bones.select { |bone| bone == name }
    raise ArgumentError if bone_search.any? && new_name.nil?
    raise ArgumentError if bone_search.empty? && !new_name.nil?
    if !new_name.nil?
      @bones.push(bone_search.first.instanceFromNonIntrinsic(new_name, measurements))
    else
      @bones.push(Bone.new(name, measurements))
    end
  end

  def hasBone(name)
    !(@bones.select { |bone| bone == name }).empty?
  end

  def getMeasurements(name)
    filtered = @bones.select { |bone| bone.name == name }
    filtered.first.measurements unless filtered.nil? || filtered.empty?
  end

  def getBoneNames
    @bones.map { |bone| bone.name }
  end
end
