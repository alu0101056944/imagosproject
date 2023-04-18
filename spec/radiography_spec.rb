RSpec.describe Radiography do
  context 'Attributes testing.' do
    it 'Radiography class exists.' do
      expect(defined? Radiography).not_to be nil
    end

    it 'A Radiography class can be instanced.' do
      expect(Radiography.new).not_to be nil
    end
  end

  context 'Bone container management operations.' do
    describe 'addBone is working as intended.' do
      it 'Can add a bone.' do
        radiography = Radiography.new
        radiography.addBone('radius', nil, { width: 2, height: 3 })
        expect(radiography.hasBone('radius')).to be true
      end

      it 'Cannot add duplicate bone names.' do
        radiography = Radiography.new
        radiography.addBone('radius', nil, { width: 2, height: 3 })
        expect { radiography.addBone('radius', nil, { width: 2, height: 3 }) }.to raise_error(ArgumentError)
      end

      it 'Can add non intrinsic bone.' do
        radiography = Radiography.new
        radiography.addBone('radius', nil, { width: 2, height: 3 })
        radiography.addBone('radius', 'ulna', { width: -1 })
        expect(radiography.hasBone('ulna')).to be true
      end
    end

    describe 'getMeasurements is working as intended.' do
      it 'Can return measurements.' do
        radiography = Radiography.new
        radiography.addBone('radius', nil, { width: 2, height: 3 })
        measurements = radiography.getMeasurements('radius')
        expect(measurements).to_not be_empty
      end

      it 'Get nil values when passing name of non contained bone as argument.' do
        radiography = Radiography.new
        expect(radiography.getMeasurements('arbitrary')).to be nil
      end
    end

    describe 'getBoneNames is working as intended.' do
      it 'Can return bone names.' do
        radiography = Radiography.new
        radiography.addBone('radius', nil, { width: 2, height: 3 })
        bone_names = radiography.getBoneNames
        expect(bone_names).to_not be_empty
      end
    end
  end
end
