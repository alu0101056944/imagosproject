# Marcos Jesús Barrios Lorenzo

# Meant to be called on show() on the DSLComparison whenever radiographies need
# to be compared. This is to enforce the design decision to have to compare
# target radiography with all of the atlas radiographies before getting a
# bone age estimation.
class ComparisonsPendingError < StandardError
  def initialize(msg = 'Target radiography has\'t been compared with all atlas radiographies.')
    super(msg)
  end
end
