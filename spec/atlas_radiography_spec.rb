RSpec.describe AtlasRadiography do
  context 'Attribute testing.' do
    it 'It is defined and can be instanced.' do
      expect(defined? AtlasRadiography).not_to be nil
      expect(AtlasRadiography.new(Radiography.new)).not_to be nil
    end
  end

  context 'Differences between two radiographies are correct.' do
    it 'Operation is correct for two whole radiographies.' do
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { length: 21 })
      radiography2 = Radiography.new
      radiography2.addBone('radius', nil, { length: 19 })
      difference = AtlasRadiography.new(radiography1).differenceScore(radiography2)
      expect(difference).to eql 2
    end

    it 'Operation is correct for two bones.' do
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { length: 21 })
      radiography1.addBone('ulna', nil, { length: 22 })
      radiography2 = Radiography.new
      radiography2.addBone('radius', nil, { length: 19 })
      radiography2.addBone('ulna', nil, { length: 23 })
      difference_radius = AtlasRadiography.new(radiography1).difference('radius', radiography2)
      expect(difference_radius).to eql 2
      difference_ulna = AtlasRadiography.new(radiography1).difference('ulna', radiography2)
      expect(difference_ulna).to eql 1
    end
  end

  context 'Incorrect difference use testing.' do
    it 'Bone level difference calculation requires bones to exist.' do
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { width: 4 })
      radiography2 = Radiography.new
      radiography2.addBone('ulna', nil, { width: 3 })
      expect do
        AtlasRadiography.new(radiography1).differenceScore(radiography2)
      end.to raise_error(DifferentBonesError)
    end

    it 'Error if trying to compare radiographies with different bones' do
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { width: 4 })
      radiography2 = Radiography.new
      radiography2.addBone('radius', nil, { width: 3, length: 5 })
      expect do
        AtlasRadiography.new(radiography1).difference('radius', radiography2)
      end.to raise_error(DifferentMeasurementsError)
    end

    it 'Error if trying to compare bones with different measurements' do
      
    end
  end
end
