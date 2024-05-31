DSLBoneAge.new do
  radiography name: 'Antonio'
  bone :radius, length: 21
  atlas name: :basicatlas, age: 8, genre: :male
  comparisons
  compare :all
  show
end
