DSLBoneAge.new do
  radiography name: 'Antonio'
  bone :radius, length: 21, width: 3
  bone :ulna, length: 20, width: 2

  atlas name: :atlas_basic_example, age: 8, genre: :male

  comparisons
  compare :all
  show

  scoringSystem

  roi 'A', :radius, score: 5
  roi 'B', :ulna, score: 3
  mean
  show
end
