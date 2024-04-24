# Marcos Jesús Barrios Lorenzo

# Meant to be called whenever the config does not have a required key
class MissingConfigKeyError < StandardError
  def initialize(msg = 'The config file is missing a required key.')
    super(msg)
  end
end
