DSLBoneAge.new do
  radiography name: 'Antonio'
  bone :radius, length: 21
  bone :ulna, length: 20

  atlas name: :atlas_basic_example, age: 8, genre: :male

  comparisons
  compare :radiographies
  age 9
  compare :radiographies
  show

  radiography name: 'Marcos'
  bone :radius, length: 20
  bone :ulna, length: 22

  comparisons
  compare :all
  show

  scoringSystem

  roi 'A', :radius, score: 5
  roi 'B', :ulna, score: 3
  mean
  show
end
