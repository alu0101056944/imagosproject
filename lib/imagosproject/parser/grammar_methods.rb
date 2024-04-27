'''
  Each class is equivalent to an inline method block for a sequence in the
  grammar.
'''

class RootNode < Treetop::Runtime::SyntaxNode
  def value
    return elements[0].text_value +
        elements[1].elements.map { |node| node.value }.join() +
        elements[2].elements.map do |node|
          node.elements[0].text_value +
          node.elements[1].value
        end.join() +
        elements[3].text_value
  end
end

class SpaceNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end

class NameLiteralNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end

class DefineAtlasNode < Treetop::Runtime::SyntaxNode
  def value
    return elements[0].text_value +
        elements[1].text_value +
        elements[2].value
  end
end

class CompareRadiographyNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end
