
require 'treetop'

require_relative 'lib/imagosproject/parser/grammar_methods.rb'
require_relative 'lib/imagosproject/parser/basic_grammar.rb'

content = %Q[
  DEFINE A foo ATLAS NAMED myGreulichPyle
  WITH THE FOLLOWING RADIOGRAPHIES
	ONE FOR GENDER male AGE 8 WITH
  	A Radius BONE OF MEASUREMENTS
    	length = 2.81230
    	width = 3.3255

  	A Radius BONE OF MEASUREMENTS
    	length = 2.1237
    	width = 3.46723

  	A Ulna BONE OF MEASUREMENTS
    	length = 2.193
    	width = 3.172327

	ONE FOR GENDER male AGE 8.5 WITH
  	A Radius BONE OF MEASUREMENTS
    	length = 2.2467
    	width = 3.7358

  	A Radius BONE OF MEASUREMENTS
    	length = 2.83689
    	width = 3.2347

  	A Ulna BONE OF MEASUREMENTS
    	length = 2.3247
    	width = 3.43

  COMPARE THE RADIOGRAPHY OBSERVED BY bar
  USING greulichPyle WITH THE myGreulichPyle ATLAS
  STARTING WITH GENDER male
  DEFINED BY
  A Radius BONE OF MEASUREMENTS
  length = 2.324
  width = 3.52832

  A Radius BONE OF MEASUREMENTS
  length = 2.1737
  width = 3.17371

  A Ulna BONE OF MEASUREMENTS
  length = 2.1848412
  width = 3.32771

  A InterSesamoids BONE OF MEASUREMENTS
  distance = 2.727122

  A Metacarpal BONE OF MEASUREMENTS
  WidthEpiphysis2 = 2.7162
  WidthEpiphysis3 = 2.82878
  WidthEpiphysis4 = 3.18723

]

parser = MyGrammarParser.new()
result = parser.parse(content)

if result
  puts result.value
else
  puts 'FAILURE.'
  puts 'Failure reason: ', parser.failure_reason
  puts 'Failure line: ', parser.failure_line
  puts 'Failure column: ', parser.failure_column
end
