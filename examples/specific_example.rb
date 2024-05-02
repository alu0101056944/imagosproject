DSLBoneAge.new do
  radiography name: 'Antonio'
  bone :radius, length: 21
  atlas name: :atlas_basic_example, age: 8, genre: :male
  comparisons
  compare :all
  show
end
