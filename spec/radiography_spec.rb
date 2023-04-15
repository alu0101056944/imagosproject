
RSpec.describe Radiography do
  context "Attributes testing" do
    it "Radiography class exists" do
      expect(defined? Radiography).not_to be nil
    end

    it "A Radiography class can be instanced" do
      expect(Radiography.new()).not_to be nil
    end
  end

  context "Bone container management operations" do
    it "Can add a bone" do
      radiography = Radiography.new
      expect(radiography.addBone("radius", false, { width:2, height:3 })).to be true
    end
    
    it "Knows when a bone is included" do
      radiography = Radiography.new
      radiography.addBone("radius", false, { width:2, height:3 })
      expect(radiography.hasBone('radius')).to be true
    end
    
    it "Can return measurements" do
      radiography = Radiography.new
      radiography.addBone("radius", false, { width:2, height:3 })
      measurements = radiography.getMeasurements("radius")
      expect(measurements).to_not be_empty
    end

    it "Can return bone names" do
      radiography = Radiography.new
      radiography.addBone("radius", false, { width:2, height:3 })
      boneNames = radiography.getBoneNames()
      expect(boneNames).to_not be_empty
    end
  end
end
