RSpec.describe DSLRadiography do
  context 'Attribute testing.' do
    it 'DSLRadiography class exists.' do
      expect(defined? DSLRadiography).not_to be nil
    end

    it 'A DSLRadiography class can be instanced.' do
      expect(DSLRadiography.new).not_to be nil
    end
  end

  context 'Bone creation is working as intended.' do
    it 'Fails if first argument is not the name.' do
      expect do
        DSLRadiography.new do
          radiography
          bone width: 3, length: 20
        end
      end.to raise_error(ArgumentError)
    end

    it 'Fails if name is not a valid symbol.' do
      expect do
        DSLRadiography.new do
          radiography
          bone nil, width: 3
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone '', width: 3
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone 'string', width: 3
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone 2, width: 3
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone true, width: 3
        end
      end.to raise_error(ArgumentError)

    end

    it 'Fails if a measurement key is not a symbol.' do
      expect do
        DSLRadiography.new do
          bone nil, width: 4, 'not a symbol' => 2
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone nil, false => 2, length: 3
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone nil, 8 => 2
        end
      end.to raise_error(ArgumentError)
    end

    it 'Fails if any measurement is not a number.' do
      expect do
        DSLRadiography.new do
          radiography
          bone :radius, width: nil
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone :radius, width: 'foo'
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone :radius, width: :foo
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          radiography
          bone :radius, width: false
        end
      end.to raise_error(ArgumentError)
    end

    it 'Fails if no measurements are passed.' do
      expect do
        DSLRadiography.new do
          radiography
          bone :radius
        end
      end.to raise_error(ArgumentError)
    end

    it 'Can instance from relative measurements.' do
      expect do
        DSLRadiography.new do
          radiography
          bone :radius, width: 3, length: 20
          bone :ulna, :relative, :radius, width: -1
        end
      end.not_to raise_error(ArgumentError)
    end
  end

  it 'Can obtain the output radiography.' do
    dsl = DSLRadiography.new do
      radiography
      bone :radius, width: 3, length: 20
      bone :ulna, width: 2, length: 20
    end
    expect(dsl.getRadiography.is_a?(Radiography)).to be true
  end

  it 'The radiography method can be called.' do
    expect(defined? DSLRadiography.new.radiography).not_to be nil
  end
end
