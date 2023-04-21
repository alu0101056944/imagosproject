RSpec.describe AtlasComparison do
  context 'Attribute testing.' do
    it 'AtlasComparison class exists.' do
      expect(defined? AtlasComparison).not_to be nil
    end

    it 'An AtlasComparison class can be instanced.' do
      expect(AtlasComparison.new).not_to be nil
    end
  end

  context 'addDifference testing.' do
    it 'Stores the difference properly.' do
      comparison = AtlasComparison.new
      comparison.addDifference(3)
      expect(comparison.getTotalDifference).to be 3
    end

    it 'Does not accept negative numbers' do
      comparison = AtlasComparison.new
      expect { comparison.addDifference(-2) }.to raise_error(ArgumentError)
    end
  end
end
