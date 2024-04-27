
require 'treetop'

require_relative('./lib/imagosproject/parser/grammar_methods.rb')
require_relative './lib/imagosproject/parser/basic_grammar.rb'

parser = MyGrammarParser.new
content = %Q[
  DEFINE something
  COMPARE
]
result = parser.parse(content)
if !result
  puts "FAILURE."
  puts "Failure reason:\n#{parser.failure_reason}"
  puts "Failure line: #{parser.failure_line}"
  puts "Failure column #{parser.failure_column}"
else
  puts result.value
end
