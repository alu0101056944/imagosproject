# Marcos Jesús Barrios Lorenzo

# Used when trying to add to an atlas a radiography on the same
# :age and genre twice.
class DuplicatedRadiographyError < StandardError
  def initialize(msg = 'Tried to add an atlas radiography to an already assigned (age, genre) pair.')
    super(msg)
  end
end
