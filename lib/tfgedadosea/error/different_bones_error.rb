# Marcos Jesús Barrios Lorenzo

# Meant to be called whenever a comparison has taken place with radiographies
# of different bones
class DifferentBonesError < StandardError
  def initialize(msg = 'The radiographies contain different bones on either side.')
    super(msg)
  end
end
