RSpec.describe DSLBoneAge do
  context 'Attributes testing.' do
    it 'DSLBoneAge class exists.' do
      expect(defined? DSLBoneAge).not_to be nil
    end

    it 'A DSLBoneAge class can be instanced.' do
      expect(DSLBoneAge.new).not_to be nil
    end
  end

  context 'Integration is correct, testing.' do
    it 'Can obtain bone age using both methods in single instance.' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 21
          bone :radius, length: 20

          age 9
          radiography
          bone :ulna, length: 22
          bone :radius, length: 20
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end
      expect do
        DSLBoneAge.new do
          radiography
          bone :radius, length: 21, width: 3
          bone :ulna, length: 20, width: 2

          atlas name: :atlas_generated_for_dsl_comparison_spec, age: 8, genre: :male

          comparisons
          compare :all
          show

          scoringSystem
          roi 'A', :radius, score: 5
          roi 'B', :ulna, score: 3
          mean
          show
        end
      end.to output(/8(.|\n)*4/).to_stdout
    end
  end
end
