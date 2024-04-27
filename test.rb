
require 'treetop'
require_relative './lib/imagosproject/parser/basic_grammar.rb'

parser = MyGrammarParser.new
content = %Q[
  DEFINE foo
]
result = parser.parse(content)
if !result
  puts "Failure reason:\n#{parser.failure_reason}"
  puts "Failure line: #{parser.failure_line}"
  puts "Failure column #{parser.failure_column}"
end
puts result.value
