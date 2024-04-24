# Marcos Jesús Barrios Lorenzo

# When a method is called outside it's context, instead of doing nothing,
# this error should be called to let the program writer know that they
# are doing something wrong
class OutOfContextError < StandardError
  def initialize(msg = 'A method call is out of it\'s intended purpose.')
    super(msg)
  end
end
