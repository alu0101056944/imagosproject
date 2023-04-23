RSpec.describe DSLScoringSystem do
  context 'Attributes testing.' do
    it 'DSLScoringSystem class exists.' do
      expect(defined? DSLScoringSystem).not_to be nil
    end

    it 'A DSLScoringSystem class can be instanced.' do
      expect(DSLScoringSystem.new).not_to be nil
    end
  end

  context 'Score adding test.' do
    it 'Can calculate the mean' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to output(/6/).to_stdout
    end

    it 'Can calculate the sum' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          sum
          show
        end
      end.to output(/12/).to_stdout
    end

    it 'Can calculate multiple scores' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          sum
          show

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to output(/12(.)*6/).to_stdout
    end
  end

  context 'Syntax testing.' do
    it 'Cannot use radiography context methods inside scoringSystem context.' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          radiography
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          bone
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to raise_error(ArgumentError)
    end

    it 'Show ends the context.' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
          radiography
          bone :clavicle
        end
      end.not_to raise_error(ArgumentError)
    end

    it 'Must pass string, score and at least one bone.' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, # error, no bone
          mean
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', :ulna # error, no score
          mean
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score score: 9 :ulna # error, no string
          mean
          show
        end
      end.to raise_error(ArgumentError)
    end

    it 'Must call show.' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
        end
      end.to raise_error(ArgumentError)
    end

    it 'Cannot use scoringSystem methods outside it\'s context.' do
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal # error

          scoringSystem
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          mean

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal # error
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to raise_error(ArgumentError)

      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23

          sum

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal # error
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean
          show
        end
      end.to raise_error(ArgumentError)
    end

    it 'Must use all defined bones of the radiography.'
      expect do
        DSLScoringSystem.new do
          radiography
          bone :ulna, length: 25
          bone :radius, length: 23
          bone :foo, radius: 3

          scoringSystem
          score 'A: falta de depósito de calcio', score: 9, :ulna, :radius, :carpal # error
          score 'B: Un solo depósito de calcio', score: 3, :clavicle
          mean # error
          show
        end
      end.to raise_error(MissingBoneCategorizations)
    end
  end
end
