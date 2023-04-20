RSpec.describe DSLAtlas do
  context 'Attributes testing.' do
    it 'DSLAtlas class exists.' do
      expect(defined? DSLAtlas).not_to be nil
    end

    it 'A DSLAtlas class can be instanced.' do
      expect(DSLAtlas.new).not_to be nil
    end
  end

  context 'Can create a new atlas.' do
    it 'Different syntax can be used.' do
      form1 = DSLAtlas.new do
        atlas

        genre :female
        age 4

        radiography
        bone :ulna,                         width: 3, height: 20
        bone :radius, :relativeTo, :ulna,     width: 1
        bone :humerus, :relativeTo, :radius,  width: 1, height: -4

        create atlas: :gp
      end
      expect(form1.getAtlas).not_to be nil
      expect(form1.getAtlas.getActiveRadiography.getBoneNames).not_to be nil

      form2 = DSLAtlas.new do
        atlas
        name :gp

        genre :female
        age 4

        radiography
        bone :ulna,                         width: 3, height: 20
        bone :radius, :relativeTo, :ulna,     width: 1
        bone :humerus, :relativeTo, :radius,  width: 1, height: -4

        create
      end
      expect(form2.getAtlas).not_to be nil
      expect(form2.getAtlas.getActiveRadiography.getBoneNames).not_to be nil

      form3 = DSLAtlas.new do
        atlas :create, name:gp

        genre :female
        age 4

        radiography
        bone :ulna,                         width: 3, height: 20
        bone :radius, :relativeTo, :ulna,     width: 1
        bone :humerus, :relativeTo, :radius,  width: 1, height: -4
      end
      expect(form3.getAtlas).not_to be nil
      expect(form3.getAtlas.getActiveRadiography.getBoneNames).not_to be nil
    end

    it 'More than one atlas can be created but only the last one counts.' do
      dsl_atlas = DSLAtlas.new do
        atlas

        genre :male
        age 7

        radiography
        bone :ulna,                         width: 3, height: 20
        bone :radius, :relativeTo, :ulna,     width: 1
        bone :humerus, :relativeTo, :radius,  width: 1, height: -4

        create atlas: :gp

        atlas

        genre :female
        age 4

        radiography
        bone :carpal,     width: 3, height: 3
        bone :metacarpal, width: 2, length: 7

        create atlas: foo
      end
      expect(dsl_atlas.getAtlas).not_to be nil

      # check which atlas was created by testing the radiography
      created_atlas = dsl_atlas.getAtlas
      created_atlas.setGender(:female)
      created_atlas.setAge(4)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setGender(:male)
      created_atlas.setAge(7)
      expect(created_atlas.getActiveRadiography).to be nil
    end
  end

  context 'Atlas loading' do
    it 'Can load an atlas from the atlas directory' do
      atlas_gp_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :gp
        end
      TEXT
      File.open('atlas/gp_created_by_spec_for_testing.rb', 'w') { |f| f.write(atlas_gp_string) }
      dsl_atlas = DSLAtlas.new do
        atlas name: :gp
      end
      expect(dsl_atlas.getAtlas).not_to be nil
    end

    it 'Error loading if no atlas in directory atlas/ has that name' do
      atlas_gp_string = <<~TEXT
        DSLAtlas.new do
          atlas :create, name: :othername
        end
      TEXT
      File.open('atlas/gp_created_by_spec_for_testing.rb', 'w') { |f| f.write(atlas_gp_string) }
      dsl_atlas = DSLAtlas.new do
        atlas name: :gp
      end
      expect(dsl_atlas.getAtlas).not_to be nil
    end
  end

  context 'Atlas radiography creation testing' do
    it 'Must be called inside the atlas creation process' do
      expect do
        DSLAtlas.new do
          radiography
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          radiography
          atlas
          create atlas: :gp
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          create atlas: :gp
          radiography
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'Atlas radiography classification testing.' do
    it 'Must specify genre and age at least once before defining an atlas radiography.' do
      expect do
        DSLAtlas.new do
          atlas
          radiography
          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
      expect do
        DSLAtlas.new do
          atlas
          radiography
          bone :ulna,                         width: 3, height: 20
          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
    end

    it 'Can use genre and/or age to change the new classification.' do
      dsl_atlas = DSLAtlas.new do
        atlas
        age 12 # initial
        genre :male # initial

        # A bunch of empty radiographies, it doesn't matter
        radiography

        genre :female

        radiography

        age 13

        radiography

        age 14

        radiography

        create atlas: :gp
      end

      created_atlas = dsl_atlas.getAtlas

      created_atlas.setGender(:male)
      created_atlas.setAge(12)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setGender(:female)
      created_atlas.setAge(12)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setGender(:female)
      created_atlas.setAge(13)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setGender(:female)
      created_atlas.setAge(14)
      expect(created_atlas.getActiveRadiography).not_to be nil
    end

    it 'ageIncrements setting implicitly changes the settings correcly.' do
      # see if two consecutive radiographies change the age according
      # to the ageIncrements specified quantity
      dsl_atlas = DSLAtlas.new do
        atlas
        age 12 # initial
        genre :male # initial
        ageIncrements 1

        # A bunch of empty radiographies, it doesn't matter
        radiography
        radiography
        radiography
        radiography

        create atlas: :gp
      end

      created_atlas = dsl_atlas.getAtlas

      created_atlas.setGender(:male)
      created_atlas.setAge(13)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(14)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(15)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(16)
      expect(created_atlas.getActiveRadiography).not_to be nil
    end

    it 'ageIncrements can be called multiple times and it works correctly.' do
      dsl_atlas = DSLAtlas.new do
        atlas
        age 12 # initial
        genre :male # initial
        ageIncrements 1

        # A bunch of empty radiographies, it doesn't matter
        radiography
        radiography

        ageIncrements 3

        radiography
        radiography

        create atlas: :gp
      end

      created_atlas = dsl_atlas.getAtlas

      created_atlas.setGender(:male)
      created_atlas.setAge(13)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(14)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(17)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(20)
      expect(created_atlas.getActiveRadiography).not_to be nil
    end

    it 'Cannot use age, genre, ageIncrements out of atlas context' do
      expect do
        DSLAtlas.new do
          atlas
          create atlas: :gp
          age 12
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          create atlas: :gp
          genre :male
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          create atlas: :gp
          ageIncrements 2
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'Radiography syntax testing.' do
    it 'add is optional.' do
      # add can be added or not, behavior is the same.
      dsl_atlas = DSLAtlas.new do
        atlas
        age 12 # initial
        genre :male # initial
        ageIncrements 1

        # A bunch of empty radiographies, it doesn't matter
        radiography
        radiography
        add
        radiography
        radiography
        add

        create atlas: :gp
      end

      created_atlas = dsl_atlas.getAtlas

      created_atlas.setGender(:male)
      created_atlas.setAge(13)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(14)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(15)
      expect(created_atlas.getActiveRadiography).not_to be nil

      created_atlas.setAge(16)
      expect(created_atlas.getActiveRadiography).not_to be nil
    end

    it 'Cannot call add without first calling radiography.' do
      expect do
        DSLAtlas.new do
          atlas

          add

          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
    end

    it 'Cannot define bones after add has been called.' do
      expect do
        DSLAtlas.new do
          atlas

          radiography
          bone :ulna, width: 3, height: 20
          add
          bone :pubis, width: 10, height: 3

          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
    end

    it 'Must call radiography at least once before calling bone.' do
      expect do
        DSLAtlas.new do
          atlas

          bone :ulna, width: 3, height: 20

          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
    end
  end

  context 'Atlas creation failure syntax.' do
    it 'Cannot call create without first calling atlas creation start syntax.' do
      expect do
        DSLAtlas.new do
          # atlas
          # name :gp
          create
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          # atlas
          create atlas: :gp
        end
      end.to raise_error(ArgumentError)
    end

    it 'Throws error on sequence of create was called.' do
      expect do
        DSLAtlas.new do
          atlas
          create atlas: :gp
          create atlas: :gp
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          name :gp
          create
          create
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          create
          create
        end
      end.to raise_error(ArgumentError)
    end

    it 'Atlas syntax variants that need start and end throw error when missing end.' do
      # check if the syntax:
      # With atlas (...) create atlas:<atlas name here>
      # With atlas (...) name: <atlas name here> (...) create
      # do not have the end create atlas
      expect do
        DSLAtlas.new do
          atlas
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          name :gp
        end
      end.to raise_error(ArgumentError)
    end

    it 'An atlas name must be given somehow.' do
      expect do
        DSLAtlas.new do
          atlas
          create
        end
      end.to raise_error(ArgumentError)
    end

    it 'Cannot create a new atlas if the previous definition has not concluded.' do
      expect do
        DSLAtlas.new do
          atlas
          atlas
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas :create, name: :gp
          atlas :create, name: :gp
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLAtlas.new do
          atlas
          name :gp
          create
          atlas
        end
      end.to raise_error(ArgumentError)
    end
  end
end
