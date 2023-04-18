RSpec.describe Bone do
  context 'Attributes testing.' do
    it 'Bone class exists.' do
      expect(defined? Bone).not_to be nil
    end

    it 'A Bone class can be instanced.' do
      expect(Bone.new('radius', { length: 5, width: 8 })).not_to be nil
    end

    it 'Exception on negative or zero valued measurements.' do
      expect { Bone.new('radius', { length: -2 }) }.to raise_error(ArgumentError)
      expect { Bone.new('radius', { length: 0 }) }.to raise_error(ArgumentError)
    end
  end

  context 'Can obtain distance to another bone.' do
    it 'Distance zero can happen.' do
      radius = Bone.new('radius', { length: 5, width: 8 })
      ulna = Bone.new('ulna', { length: 5, width: 8 })
      expect(radius.distanceFrom(ulna)).to eql 0
    end

    it 'Name does not matter.' do
      radius = Bone.new('foo', { length: 2 })
      ulna = Bone.new('xyzz', { length: 7 })
      expect(radius.distanceFrom(ulna)).to eql 5
    end

    it 'All measurement names are equal is handled correctly.' do
      radius_bone1 = Bone.new('radius', { length: 5, width: 8 })
      radius_bone2 = Bone.new('radius', { length: 7, width: 9 })
      expect(radius_bone1.distanceFrom(radius_bone2)).to eql 3
    end

    it 'Some measurement names are different is handled correctly.' do
      radius_bone1 = Bone.new('radius', { length: 5, density: 92.4 })
      radius_bone2 = Bone.new('radius', { length: 7, width: 9 })
      expect(radius_bone1.distanceFrom(radius_bone2)).to eql 2
    end

    it 'Is Commutative operation.' do
      scaphoid = Bone.new('scaphoid', { width: 6, height: 3 })
      hamate = Bone.new('hamate', { width: 3, height: 3 })
      distance1 = scaphoid.distanceFrom(hamate)
      distance2 = hamate.distanceFrom(scaphoid)
      expect(distance1).to eql distance2
    end
  end

  context 'Implements Comparable.' do
    it 'Can use boolean comparison operators for naming.' do
      # equal measurements
      trapezoid = Bone.new('trapezoid', { width: 3, height: 4 })

      expect(trapezoid == 'trapezoid').to be true
      expect(trapezoid != 'tubercleTrapezium').to be true
    end
  end

  context 'Non intrinsic measurements instantiation.' do
    it 'Accepts both negative and positive values.' do
      skull = Bone.new('skull', { width: 20, height: 35, length: 21 })
      expect { skull.instanceFromNonIntrinsic('cervical', { length: -17 }) }.not_to raise_error
      expect { skull.instanceFromNonIntrinsic('cervical', { length: 17 }) }.not_to raise_error
    end

    it 'Does not accept negative values that result in negative total.' do
      ulna = Bone.new('ulna', { width: 2, length: 50 })
      expect { ulna.instanceFromNonIntrinsic('radius', {width: -3 }) }.to raise_error(ArgumentError)
    end

    it 'Does not accept zero values.' do
      humerus = Bone.new('humerus', { width: 3, length: 35 })
      expect { humerus.instanceFromNonIntrinsic('foo', { width: -3 }) }.to raise_error(ArgumentError)
    end
  end
end
