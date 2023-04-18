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
    it 'Fails if first argument is not the name' do
      expect { DSLRadiography.new { bone width: 3, length: 20 } }.to raise_error(ArgumentError)
    end

    it 'Fails if name is not a valid symbol' do
      expect { DSLRadiography.new { bone nil, width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone '', width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone 'string', width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone 2, width: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone true, width: 3 } }.to raise_error(ArgumentError)
    end

    it 'Fails if a measurement key is not a symbol' do
      expect { DSLRadiography.new { bone nil, width: 4, 'not a symbol' => 2 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone nil, false => 2, length: 3 } }.to raise_error(ArgumentError)
      expect { DSLRadiography.new { bone nil, 8 => 2 } }.to raise_error(ArgumentError)
    end

    it 'Fails if any measurement is not a number' do
      expect do
        DSLRadiography.new do
          bone :radius, width: nil
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone :radius, width: 'foo'
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone :radius, width: :foo
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLRadiography.new do
          bone :radius, width: false
        end
      end.to raise_error(ArgumentError)
    end

    it 'Fails no measuremets are passed' do
      expect do
        DSLRadiography.new do
          bone :radius
        end
      end.to raise_error(ArgumentError)
    end

    it 'Can instance from relative measurements' do
      expect do
        DSLRadiography.new do
          bone :radius, width: 3, length: 20
          bone :ulna, :relative, width: -1
        end
      end.not_to raise_error(ArgumentError)
    end
  end

  it 'Can obtain the output radiography' do
    dsl = DSLRadiography.new do
      bone :radius, width: 3, length: 20
      bone :ulna, width: 2, length: 20
    end
    expect(dsl.getRadiography.is_a?(Radiography)).to be true
  end

  it 'The radiography method can be called' do
    expect(DSLRadiography.new.radiography.defined?).to be true
  end
end
