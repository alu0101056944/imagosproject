'''
  Each class is equivalent to an inline method block for a sequence in the
  grammar.
'''

class RootNode < Treetop::Runtime::SyntaxNode
  def value
    (space1, statement, statements, space2) = elements()
    return "#{statement.elements.map do |node|
          node.value
        end.join()} #{statements.elements.map do |node|
              node.elements[1].value
            end.join()}"
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

class NumberNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end

class StringNode < Treetop::Runtime::SyntaxNode
  def value
    (slash1, name_space, slash2) = elements()
    return name_space.text_value
  end
end

class DefineAtlasNode < Treetop::Runtime::SyntaxNode
  def value
    (define, space1, optional_a, name1, space2, atlas, space3, named, space4,
        name2, space5, with, space6, optional_the, optional_following,
        optional_radiographies, atlasRadiographyDef) = elements()
    return "atlas\n#{
          atlasRadiographyDef.elements.map do |node|
            node.value
          end.join()
        }create atlas: " +
        ":#{name1.text_value}\n\n"
  end
end

class DefineROINode < Treetop::Runtime::SyntaxNode
  def value
    (define, space1, optional_a, name1, space2, scoring, space3, system_, space4,
        named, space5, name2, space6, with, space7, optional_the,
        optional_following, optional_roi, roiDefinition) = elements()
    return "scoringSystem\n#{
          roiDefinition.elements.map do |node|
            node.value
          end.join()
        }mean\nshow\n\n"
        # "mean" always because I have to change scoring system to
        # definition and then usage instead of direct usage
  end
end

class CompareRadiographyNode < Treetop::Runtime::SyntaxNode
  def value
    (compare, space1, optional_the1, radiography, space2, optional_observed_by,
        using_, space3, optional_the2, name2, space4, method, starting, space5,
        with, space6, gender, space7, name3, space8, defined, space9, by,
        space10, boneMeasurements
    ) = elements()
    # Temporarily only works with the atlas, cannot load a roi
    return "radiography name: '#{optional_observed_by.elements[4].text_value}'\n" +
        "#{boneMeasurements.elements.map do |node|
          node.value
        end.join()}\natlas name: :#{name2.text_value}, genre: " +
            ":#{name3.text_value}\ncomparisons\ncompare :all\nshow\n\n"
  end
end

# TODO: if atlas check age and gender, otherwise dont
# TODO: think on whether i should delete the load sintax and leave it for compare
# statement only
class LoadNode < Treetop::Runtime::SyntaxNode
  def value
    (load_, space1, optional_the, method, named, space2, name, space3, starting,
        space4, with, space5, gender, space6, name2, space7, age, space8,
        number, space9) = elements()
      # temporarily left as atlas version always because ROI cannot be
      # defined-loaded but only used directly.
      return "atlas name: :#{name.text_value}, genre: :#{name2.text_value}, " +
          "age: #{number.text_value}\n\n"
  end
end

class AtlasRadiographyDefinitionNode < Treetop::Runtime::SyntaxNode
  def value
    (binSelection, space1, boneMeasurements) = elements()
    return "#{binSelection.value}#{boneMeasurements.elements.map do |node|
          node.value
        end.join()}\n"
  end
end

class BinSelectionNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_one, for_, space1, gender, space2, name, space3, age, space4,
        number, space5, with) = elements()
    return "genre :#{name.text_value}\nage #{number.text_value}\nradiography\n"
  end
end

class BoneMeasurementsNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_a, name, space1, bone, space2, of, space3, measurements, space5,
        measurements) = elements()
    return "bone :#{name.text_value}, #{measurements.elements.map do |node|
          node.elements[0].value
        end.join(', ')}\n"
  end
end

class ROIDefinitionNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_one, described, space1, as, space2, string, space3, with, space4,
    score, space5, number, space6, composed, space7, of, space8, boneList) =
        elements()
    return "roi '#{string.value}', #{boneList.value}, score: #{number.text_value}\n"
  end
end

class BoneListNode < Treetop::Runtime::SyntaxNode
  def value
    (name, space1, name2) = elements()
    return ":#{name.text_value}, #{name2.elements.map do |node|
          ':' + node.elements[2].text_value
        end.join(', ')}"
  end
end

class MeasurementNode < Treetop::Runtime::SyntaxNode
  def value
    (name, space1, eq, space2, number) = elements()
    return "#{name.text_value}: #{number.text_value}"
  end
end
