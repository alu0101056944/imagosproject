# Changes from the initial design

The initial design can change with the new information gained during the process of implementation. This document records the changes. Changes are reflected on the UML diagram.

## Non intrinsic bone instantiation

instanceFromNonIntrinsic() needs to get the name of the new bone, otherwise a duplicate will be generated, and thats illegal. addBone() has to receive the new name too.

