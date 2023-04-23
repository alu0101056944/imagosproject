# Simple data class
RSpec.describe RegionOfInterest do
  context 'Attributes testing.' do
    it 'RegionOfInterest class exists.' do
      expect(defined? RegionOfInterest).not_to be nil
    end

    it 'A RegionOfInterest class can be instanced.' do
      description = 'A: falta de depósito de calcio'
      bone_names = %i[ulna radius carpal]
      expect(RegionOfInterest.new(description, bone_names)).not_to be nil
    end

    it 'Can set the score of the RegionOfInterest.' do
      description = 'A: falta de depósito de calcio'
      bone_names = %i[ulna radius carpal]
      region_of_interest = RegionOfInterest.new(description, bone_names)
      expect(region_of_interest.getScore).to be 0
      region_of_interest.setScore(4)
      expect(region_of_interest.getScore).to be 4
    end
  end
end
