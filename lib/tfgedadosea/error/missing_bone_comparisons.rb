# Marcos Jesús Barrios Lorenzo

# Used when bone level comparison takes place and not all bones have been
# called for comparison.
class MissingBoneComparisons < StandardError
  def initialize(msg = 'Not all bones have been compared. Add comparisons.')
    super(msg)
  end
end
