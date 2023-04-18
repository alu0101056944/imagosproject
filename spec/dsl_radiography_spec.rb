RSpec.describe DSLRadiography do
  context 'Attribute testing.' do
    it 'DSLRadiography class exists.' do
      expect(defined? DSLRadiography).not_to be nil
    end

    it 'A DSLRadiography class can be instanced.' do
      expect(DSLRadiography.new).not_to be nil
    end
  end

  context 'Bone creation is working as intended' do
    it 'Fails if first argument is not a name key' do
      expect { DSLRadiography.new { bone width: 3, length: 20 } }.to raise_error(ArgumentError)
    end

    it 'Fails if name is not a valid string' do
      expect { DSLRadiography.new { bone name: nil, width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone name: '', width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone name: 2, width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone name: true, width: 3 } }.to raise_error(ArgumentError)
    end

    it 'Fails if any measurement is not a number' do
      expect do
        DSLRadiography.new do
          bone name: 'radius', width: nil
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone name: 'radius', width: 'foo'
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone name: 'radius', width: :foo
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone name: 'radius', width: false
        end
      end.to raise_error(ArgumentError)
    end

    it 'Fails no measuremets are passed' do
      expect do
        DSLRadiography.new do
          bone name: 'radius'
        end
      end.to raise_error(ArgumentError)
    end
  end

  it 'Can obtain the output radiography' do
    dsl = DSLRadiography.new do
      bone name: 'radius', width: 3, length: 20
      bone name: 'ulna', width: 2, length: 20
    end
    expect(dsl.getRadiography.is_a?(Radiography)).to be true
  end

  it 'The radiography method can be called' do
    expect(DSLRadiography.new.radiography.defined?).to be true
  end
end
