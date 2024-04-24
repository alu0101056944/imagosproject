# Marcos Jesús Barrios Lorenzo

# Simple container of bones.
class Radiography
  def initialize
    @bones = []
    @observer_name = nil
  end

  # if new_name is nil then instance from scratch. Otherwise it is
  # non intrinsic instancing.
  def addBone(name, new_name, measurements)
    bone_search = @bones.select { |bone| bone == name }
    raise ArgumentError if new_name.nil? && bone_search.any?  ||
                           !new_name.nil? && bone_search.empty?

    if new_name.nil?
      @bones.push(Bone.new(name, measurements))
    else
      @bones.push(bone_search.first.instanceFromNonIntrinsic(new_name, measurements))
    end
  end

  def hasBone(name)
    (@bones.select { |bone| bone == name }).any?
  end

  def getMeasurements(name)
    filtered = @bones.select { |bone| bone.name == name }
    filtered.first.measurements unless filtered.nil? || filtered.empty?
  end

  def getBoneNames
    @bones.map { |bone| bone.name }
  end

  attr_accessor :observer_name
end
