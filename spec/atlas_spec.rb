RSpec.describe Atlas do
  context 'Attributes testing.' do
    it 'Atlas class exists.' do
      expect(defined? Atlas).not_to be nil
    end

    it 'A Atlas class can be instanced.' do
      expect(Atlas.new(:gp)).not_to be nil
    end
  end

  context 'setGender and setAge testing.' do
    it 'Can change the active gender and age of the atlas.' do
      # Add radiographies by genre, check if active radiographies change
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { length: 20, width: 4 })

      radiography2 = Radiography.new
      radiography2.addBone('bone1', nil, { length: 20, width: 4 })

      atlas = Atlas.new(:tw)
      atlas.addRadiography(radiography1, 15, :male)
      atlas.addRadiography(radiography2, 17, :female)

      atlas.setGender(:male)
      atlas.setAge(15)
      expect(atlas.getActiveRadiography.hasBone('radius')).to be true
      expect(atlas.getActiveRadiography.hasBone('bone1')).to be false
      atlas.setGender(:female)
      atlas.setAge(17)
      expect(atlas.getActiveRadiography.hasBone('bone1')).to be true
      expect(atlas.getActiveRadiography.hasBone('radius')).to be false
    end

    it 'Default gender is male.' do
      # add male and female radiographies, dont set genre, check
      # which radiography was given
      # Add radiographies by genre, check if active radiographies change
      radiography1 = Radiography.new
      radiography1.addBone('radius', nil, { length: 20, width: 4 })

      radiography2 = Radiography.new
      radiography2.addBone('bone1', nil, { length: 20, width: 4 })

      atlas = Atlas.new(:tw)
      atlas.addRadiography(radiography1, 15, :male)
      atlas.addRadiography(radiography2, 17, :female)

      atlas.setGender(:male)
      atlas.setAge(15)
      expect(atlas.getActiveRadiography.hasBone('radius')).to be true
      expect(atlas.getActiveRadiography.hasBone('bone1')).to be false
      atlas.setGender(:female)
      atlas.setAge(17)
      expect(atlas.getActiveRadiography.hasBone('bone1')).to be true
      expect(atlas.getActiveRadiography.hasBone('radius')).to be false
    end

    it 'Must receive :symbol. Raise Error if it is not.' do
      atlas = Atlas.new(:tw)
      expect { atlas.setGender('foo') }.to raise_error(ArgumentError)
      expect { atlas.setGender(2) }.to raise_error(ArgumentError)
      expect { atlas.setGender(true) }.to raise_error(ArgumentError)
    end
  end
end
