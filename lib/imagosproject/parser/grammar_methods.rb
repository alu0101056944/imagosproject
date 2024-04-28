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

class NumberNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end

class StringNode < Treetop::Runtime::SyntaxNode
  def value
    return text_value
  end
end

class DefineAtlasNode < Treetop::Runtime::SyntaxNode
  def value
    (define, space1, optional_a, name1, space2, atlas, space3, named, space4,
        name2, space5, with, space6, optional_the, optional_following,
        optional_radiographies, atlasRadiographyDef) = elements()
    return define.text_value + space1.text_value + optional_a.text_value +
        name1.text_value + space2.text_value + atlas.text_value +
        space3.text_value + named.text_value + space4.text_value +
        name2.text_value + space5.text_value + with.text_value +
        space6.text_value + optional_the.text_value +
        optional_following.text_value + optional_radiographies.text_value +
        atlasRadiographyDef.text_value
  end
end

class DefineROINode < Treetop::Runtime::SyntaxNode
  def value
    (define, space1, optional_a, name1, space2, scoring, space3, system_, space4,
        named, space5, name2, space6, with, space7, optional_the,
        optional_following, optional_roi, roiDefinition) = elements()
    return define.text_value + space1.text_value + optional_a.text_value +
        name1.text_value + space2.text_value + scoring.text_value +
        space3.text_value + system_.text_value + space4.text_value +
        named.text_value + space5.text_value + name2.text_value +
        space6.text_value + with.text_value + space7.text_value +
        optional_the.text_value + optional_following.text_value +
        optional_roi.text_value + roiDefinition.text_value
  end
end

class CompareRadiographyNode < Treetop::Runtime::SyntaxNode
  def value
    (compare, space1, optional_the1, radiography, space2, optional_observed_by,
        using_, space3, optional_the2, space4, name2, method, starting, space5,
        with, space6, gender, space7, name3, space8, defined, space9, by,
        space10, boneMeasurements
    ) = elements()
    return compare.text_value + space1.text_value + optional_the1.text_value +
        radiography.text_value + space2.text_value +
        optional_observed_by.text_value + using_.text_value + space3.text_value +
        optional_the2.text_value + space4.text_value + name2.text_value +
        method.text_value + starting.text_value + space5.text_value +
        with.text_value + space6.text_value + gender.text_value +
        space7.text_value + name3.text_value + space8.text_value +
        defined.text_value + space9.text_value + by.text_value +
        space10.text_value + boneMeasurements.text_value
  end
end

# TODO: if atlas check age and gender, otherwise dont
class LoadNode < Treetop::Runtime::SyntaxNode
  def value
    (load_, space1, optional_the, method, named, space2, name, space3, starting,
        space4, with, space5, gender_and_age) =
        elements()
    return load_.text_value + space1.text_value + optional_the.text_value +
        method.text_value + named.text_value + space2.text_value +
        name.text_value + space3.text_value + starting.text_value +
        space4.text_value + with.text_value + space5.text_value +
        gender_and_age.text_value
  end
end

class AtlasRadiographyDefinitionNode < Treetop::Runtime::SyntaxNode
  def value
    (binSelection, space1, boneMeasurements) = elements()
    return binSelection.value + space1.text_value +
        boneMeasurements.elements.map do |node|
          node.value
        end.join()
  end
end

class BinSelectionNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_one, for_, space1, gender, space2, name, space3, age, space4,
        number, space5, with) = elements()
    return optional_one.text_value + for_.text_value + space1.text_value +
        gender.text_value + space2.text_value + name.text_value +
        space3.text_value + age.text_value + space4.text_value +
        number.text_value + space5.text_value + with.text_value
  end
end

class BoneMeasurementsNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_a, name, space1, bone, space2, of, space3, measurements, space5,
        measurements) = elements()
    return optional_a.text_value + name.text_value + space1.text_value +
        bone.text_value + space2.text_value + of.text_value + space3.text_value +
        measurements.text_value + space5 + measurements
  end
end

class ROIMetaNode < Treetop::Runtime::SyntaxNode
  def value
    (optional_one, described, space1, as, space2, string, space3, with, space4,
    score, space5, number, space6, composed, space7, of, space8) = elements()
    return optional_one.text_value + described.text_value + space1.text_value +
        as.text_value + space2.text_value + string.text_value +
        space3.text_value + with.text_value + space4.text_value +
        score.text_value + space5.text_value + number.text_value +
        space6.text_value + composed.text_value + space7.text_value +
        of.text_value + space8.text_value
  end
end

class BoneListNode < Treetop::Runtime::SyntaxNode
  def value
    (name, space1, name2) = elements()
    return name.text_value + space1.text_value + name2.text_value
  end
end

class MeasurementNode < Treetop::Runtime::SyntaxNode
  def value
    (name, space1, eq, space2, number) = elements()
    return name.text_value + space1.text_value + eq.text_value +
        space2.text_value + number.text_value
  end
end
