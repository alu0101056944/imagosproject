# Changes from the initial design

The initial design can change with the new information gained during the process of implementation. This document records the changes. Changes are reflected on the UML diagram.

## Non intrinsic bone instantiation

instanceFromNonIntrinsic() needs to get the name of the new bone, otherwise a duplicate will be generated, and thats illegal. addBone() has to receive the new name too.

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

Bone of <code>DSLRadiography</code> now has as first parameter a variable length array so that it can accept a <code>:relative</code> keyword which instructs <code>DSLRadiography</code> to instance a relative bone and not an intrinsic bone.