
RSpec.describe Bone do
  context "Attributes testing" do
    it "Bone class exists" do
      expect(defined? Bone).not_to be nil
    end

    it "A Bone class can be instanced" do
      expect(Bone.new("radius", { length:5, width:8 })).not_to be nil
    end

    it "Exception on negative or zero valued measurements" do
      expect { Bone.new("radius", { length:-2 }) }.to raise_error(Errors::ArgumentError)
      expect { Bone.new("radius", { length:0 }) }.to raise_error(Errors::ArgumentError)
    end

  end

  context "Can obtain distance to another bone" do
    it "Distance zero can happen" do
      radius = Bone.new("radius", { length:5, width:8 })
      ulna = Bone.new("ulna", { length:5, width:8 })
      expect(radius.distanceFrom(ulna)).to eql 0
    end

    it "Name does not matter" do
      radius = Bone.new("foo", { length:2 })
      ulna = Bone.new("xyzz", { length:7 })
      expect(radius.distanceFrom(ulna)).to eql 0
    end

    it "All measurement names are equal is handled correctly" do
      radiusBoneA = Bone.new("radius", { length:5, width:8 })
      radiusBoneB = Bone.new("radius", { length:7, width:9 })
      expect(radiusBoneA.distanceFrom(radiusBoneB)).to eql 3
    end

    it "Some measurement names are different is handled correctly" do
      radiusBoneA = Bone.new("radius", { length:5, density:92.4 })
      radiusBoneB = Bone.new("radius", { length:7, width:9 })
      expect(radiusBoneA.distanceFrom(radiusBoneB)).to eql 2
    end

    it "Is Commutative operation" do
      scaphoid = Bone.new("scaphoid", { width:6, height:3 })
      hamate = Bone.new("hamate", { width:3, height:3 })
      distanceA = scaphoid.distanceFrom(hamate)
      distanceB = hamate.distanceFrom(scaphoid)
      expect(distanceA).to eql distanceB
    end
  end

  context "Implements Comparable" do
    it "Can use boolean comparison operators" do
      # equal measurements
      trapezoid = Bone.new("trapezoid", { width:3, height:4 })
      pisiform = Bone.new("pisiform", { width:3, height:4 })

      # different measurements
      tubercleTrapezium = Bone.new("tubercleTrapezium", { width:4, height:6 })
      capitate = Bone.new("capitate", { width:8, height: 9})

      expect(trapezoid < tubercleTrapezium < capitate).to be true

      expect(capitate >= trapezoid).to be true
      expect(capitate >= pisiform).to be true
      expect(capitate >= tubercleTrapezium).to be true

      expect(trapezoid == pisiform).to be true
      expect(trapezoid != tubercleTrapezium).to be true
      expect(capitate != tubercleTrapezium).to be true
    end
  end

  context "Non intrinsic measurements instantiation" do
    it "Instancing working properly" do
      lunate = Bone.new("lunate", { width:4, height:4 })
      lunateRelative = lunate.instanceFromNonIntrinsic({ name:"hamate", width:1 })
      expect(lunateRelative).to eql(Bone.new("hamate", { width:5, height:4 }))
    end

    it "Accepts both negative and positive values" do
      skull = Bone.new("skull", { width:20, height:35, length:21 })
      expect { skull.instanceFromNonIntrinsic({ length:-17}) }.not_to raise_error(Errors::ArgumentError)
      expect { skull.instanceFromNonIntrinsic({ length:17}) }.not_to raise_error(Errors::ArgumentError)
    end

    it "Does not accept negative values that result in negative total" do
      ulna = Bone.new("ulna", { width:2, length:50 })
      expect { ulna.instanceFromNonIntrinsic({ name:"clavicle", width:-3}) }.to raise_error(Errors::ArgumentError)
    end

    it "Does not accept zero values" do
      humerus = Bone.new("humerus", { width:3, length:35 })
      expect { humerus.instanceFromNonIntrinsic({ width:-3 }) }.to raise_error(Errors:ArgumentError)
    end
  end

end
