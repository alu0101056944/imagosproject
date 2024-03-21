DSLAtlas.new do
  atlas :create, name: :atlas_generated_for_dsl_comparison_spec
  genre :male
  age 8
  
  radiography
  bone :ulna, length: 21
  bone :radius, length: 20
  ageIncrements 1

  radiography
  bone :ulna, length: 22
  bone :radius, :relative, :ulna, length: -2
end
