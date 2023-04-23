RSpec.describe DSLComparison do
  context 'Attributes testing.' do
    it 'DSLComparison class exists.' do
      expect(defined? DSLComparison).not_to be nil
    end

    it 'A DSLComparison class can be instanced.' do
      expect(DSLComparison.new).not_to be nil
    end
  end

  context 'Syntax testing.' do
    it 'Can compare at bone level.' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          # alternative 1: compare individual bones, navigate by age
          age 8
          compare :ulna
          decide

          age 9
          compare :ulna
          decide

          show
        end
      end.to output(/8/).to_stdout
    end

    it 'Can compare at radiography level' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          # alternative 1: compare individual bones, navigate by age
          age 8
          compare :radiographies
          decide

          age 9
          compare :radiographies # optional parameter
          decide

          show
        end
      end.to output(/8/).to_stdout
    end

    it 'Can compare all' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :all
          show
        end
      end.to output(/8/).to_stdout
    end

    it 'Can compare multiple times' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :all
          show

          radiography
          bone :ulna, length: 28

          comparisons
          compare :all
          show
        end
      end.to output(/8(.|\n)*9/).to_stdout
    end
  end

  context 'Incorrect syntax testing.' do
    it 'Must have a radiography and an atlas loaded.' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          # No radiography loaded

          comparisons

          age 8
          compare :radiographies

          age 9
          compare :radiographies # optional parameter
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLComparison.new do
          radiography # error; cannot set a radiography inside comparisons context
          bone :ulna, length: 24

          # no atlas loaded

          comparisons

          age 8
          compare :radiographies

          age 9
          compare :radiographies # optional parameter
          show
        end
      end.to raise_error(ArgumentError)
    end

    it 'Cannot call non compare commands inside comparisons' do
      expect do
        DSLComparison.new do
          comparisons
          radiography # error
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLComparison.new do
          comparisons
          atlas :create, name: :foo # error
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLComparison.new do
          comparisons
          bone # error
        end
      end.to raise_error(ArgumentError)
    end

    it 'show ends comparisons context' do
      expect do
        DSLComparison.new do
          radiography
          atlas
          comparisons
          show
          radiography
        end
      end.not_to raise_error(ArgumentError)
    end

    it 'decide is optional' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          age 8
          compare :radiographies

          age 9
          compare :radiographies # optional parameter
          show
        end
      end.not_to raise_error(ArgumentError)
    end

    it 'show needs to always be called.' do
      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :all
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          age 8
          compare :radiographies
          decide

          age 9
          compare :radiographies # optional parameter
          decide
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          # alternative 1: compare individual bones, navigate by age
          age 8
          compare :ulna
          decide

          age 9
          compare :ulna
          decide
        end
      end.to raise_error(ArgumentError)
    end

    it 'Must compare all bones when doing bone level comparison.' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24
          bone :radius, length: 23

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :ulna
          decide # error, incomplete bone comparison

          show
        end
      end.to raise_error(MissingBoneComparisons)

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24
          bone :radius, length: 23

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :ulna

          continue
          compare :radiographies # error, previous comparison incomplete
          show
        end
      end.to raise_error(MissingBoneComparisons)

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24
          bone :radius, length: 23

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :ulna

          continue
          compare :all # error, previous comparison incomplete
          show
        end
      end.to raise_error(MissingBoneComparisons)
    end
  end

  # old navigation with age and genre is the same as with atlas spec and
  # thus it can already tested on the dsl_atlas spec
  context 'Navigation testing.' do
    it 'continue jumps to the next age inside the genre.' do
      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age 8
          radiography
          bone :ulna, length: 24

          age 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :radiographies
          continue
          compare :radiographies

          show
        end
      end.to output(/8/).to_stdout

      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :male, age: 8

          comparisons
          compare :radiographies
          nextReference
          compare :radiographies

          show
        end
      end.to output(/8/).to_stdout
    end
  end
end
