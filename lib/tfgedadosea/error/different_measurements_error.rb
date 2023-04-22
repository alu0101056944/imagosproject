# Marcos Jesús Barrios Lorenzo

# Meant to be called whenever a comparison has taken place with bones
# of different measurements
class DifferentMeasurementsError < StandardError
  def initialize(msg = 'The bones contain different measurements on either side.')
    super(msg)
  end
end
