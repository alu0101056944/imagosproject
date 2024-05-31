DSLAtlas.new do
  atlas :create, name: :atlas_generated_for_dsl_comparison_spec
  genre :male
  age 8
  
  radiography
  bone :radius, length: 21

  age 9
  radiography
  bone :radius, length: 21.2
end
