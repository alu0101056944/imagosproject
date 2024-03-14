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
          bone :radius, length: 21
          bone :ulna, length: 20

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

  context 'Context switch error detection' do
    it 'Cannot call different context specific methods on other contexts' do
      expect do
        DSLBoneAge.new do
          radiography

          # was in radiography creation context, this should not be here
          roi 'A', :radius, score: 5 
        end
      end.to raise_error(OutOfContextError)

      expect do
        DSLBoneAge.new do
          atlas name: :gp_created_by_spec_for_testing, age: 8, genre: :female
          # roi belongs to the scoringSystem context and not to the the atlas
          # creation context
          roi 'A', :radius, score:5
          create
        end
      end.to raise_error(OutOfContextError)

      # @TODO test the rest of the OutOfContextErrors
    end
  end
end
