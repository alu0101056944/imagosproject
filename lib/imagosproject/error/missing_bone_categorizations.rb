# Marcos Jesús Barrios Lorenzo

# Used on scoring system when bones of the target radiography have not been
# added to one score category.
class MissingBoneCategorizations < StandardError
  def initialize(msg = 'Not all bones have been categorized.')
    super(msg)
  end
end
