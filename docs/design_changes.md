# Changes from the initial design

The initial design can change with the new information gained during the process of implementation. This document records the changes. Changes are reflected on the UML diagram.

## Non intrinsic bone instantiation

instanceFromNonIntrinsic() needs to get the name of the new bone, otherwise a duplicate will be generated, and thats illegal. addBone() has to receive the new name too.

## Radiography getBoneMeasurements now returns the hash with the measurements in full and not just the name.

## Commas between key-values 

On the images shown in the original work, it is shown an expression like the following:

```ruby
bone :ulna length: 2 width: 3
```

But in reality, ruby only accepts something like:

```ruby
bone :ulna, length: 2, width: 3
```

Commas could be removed later, but for now they are staying.

## Variable length argument array before variable length argument hash

Bone of <code>DSLRadiography</code> now has as first parameter a variable length array so that it can accept a <code>:relative</code> or <code>relativeTo</code> keyword which instructs <code>DSLRadiography</code> to instance a relative bone and not an intrinsic bone.

## Information delay for object creation

Because the syntax is flexible, sometimes an incomplete instance needs to be created, so that it becomes complete slowly as the script advances, until a certain end point is reached where the context ends and it needs to be completed. This means that setters need to be made and constructors do not require all the information.

Thats why some classes like atlas got setters that were not in the initial class diagram.

## age Increments method 

Atlas needs to provide a way to increment the active age. Original design didnt have it. A relative flag was added to setAge.

## addRadiography of Atlas

Because active age and active gender is not know at dsl level, changed them to optional parameters.

## Atlas @activeRadiography

It is not needed because the active radiography can be obtained from the active age and gender and there is no need to keep a reference on the atlas class.

## Composition on DSLComparison

DSLComparison now uses a DSLAtlas and a DSLRadiography to avoid duplication and to reduce spec files.

## DSLComparison loadAtlas method no longer needed

## DSLComparison now has <code>name</code> method. It is necessary for compatibility with DSLAtlas but it was not reflected on the initial design.

## DSLComparison now has <code>add</code> method. It is necessary for compatibility with DSLAtlas but it was not reflected on the initial design.

## DSLComparison does not need to implement the loadAtlas method, because it simply calls the equivalent DSAtlas method when in it's context

## DSLComparison no longer uses comparison related class, but the task itself of comparison is given to the Atlas class.

## Atlas now provides a next method and a reset method to allow dsl comparisons to move from one atlas radiography to the next.
