RSpec.describe DSLComparison do
  context 'Attributes testing.' do
    it 'DSLComparison class exists.' do
      expect(defined? DSLComparison).not_to be nil
    end

    it 'A DSLComparison class can be instanced.' do
      expect(DSLComparison.new).not_to be nil
    end
  end

  context 'Can compare radiography with different syntaxis.' do
    it 'Can compare at bone level.' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        comparisons
        # alternative 1: compare individual bones, navigate by age
        age 8
        compare :ulna
        compare :radius
        compare :carpal
        compare :metacarpal
        decide

        age 9
        compare :ulna
        compare :radius
        compare :carpal
        compare :metacarpal
        decide

        show
      end
      expect($print_result).to be 8
    end

    it 'Can compare at radiography level' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

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
      expect($print_result).to be 8
    end

    it 'Can compare all' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
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
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

          comparisons
          # alternative 1: compare individual bones, navigate by age
          age 8
          compare :ulna
          compare :radius
          decide
          show
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'Comparison syntax testing' do
    it 'decide is optional unless doing bone level comparisons' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
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
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

          comparisons
          age 8
          compare :radiographies
  
          age 9
          compare :radiographies # optional parameter
          show
        end
      end.not_to raise_error(ArgumentError)

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        comparisons
        age 8
        compare :ulna
        compare :radius
        compare :carpal
        compare :metacarpal

        age 9
        compare :ulna
        compare :radius
        compare :carpal
        compare :metacarpal
        decide

        show
      end.to raise_error(ArgumentError)

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        comparisons
        age 8
        compare :ulna
        compare :radius
        compare :carpal
        compare :metacarpal

        show
      end.to raise_error(ArgumentError)
    end

    it 'show needs to always be called always' do
      expect do
        DSLComparison.new do
          # set target radiography
          radiography
          bone :ulna, length: 24

          # load atlas
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

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
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

          comparisons
          # alternative 1: compare individual bones, navigate by age
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
          atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

          comparisons
          # alternative 1: compare individual bones, navigate by age
          age 8
          compare :ulna
          compare :radius
          compare :carpal
          compare :metacarpal
          decide

          age 9
          compare :ulna
          compare :radius
          compare :carpal
          compare :metacarpal
          decide
        end
      end.to raise_error(ArgumentError)
    end

    it 'Must compare all bones before calling decide' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        comparisons
        compare :all
        show
      end
      expect($print_result).to be 8
    end
  end

  # old navigation with age and genre is the same as with atlas spec and thus tested
  # with the dsl atlas spec context for dsl comparison in the
  # spec/dsl_comparison_spec_atlas_context.rb file
  context 'Active radiographies to be compared new navigation testing.' do
    it 'continue jumps to the next age inside the genre.' do
      $print_result = ''
      def print(string_to_print)
        $print_result = string_to_print
      end

      create_atlas_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :atlas_generated_for_dsl_comparison_spec
          genre :male

          age: 8
          radiography
          bone :ulna, length: 24

          age: 9
          radiography
          bone :ulna, length: 28
        end
      TEXT
      File.open('atlas/atlas_generated_for_dsl_comparison_spec.rb', 'w') do |f|
        f.write(create_atlas_string)
      end

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        compare :radiography
        continue
        compare :radiography

        show
      end
      expect($print_result).to be 8

      DSLComparison.new do
        # set target radiography
        radiography
        bone :ulna, length: 24

        # load atlas
        atlas name: :atlas_generated_for_dsl_comparison_spec, genre: :female

        compare :radiography
        nextReference
        compare :radiography

        show
      end
      expect($print_result).to be 8
    end
  end
end
