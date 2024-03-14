# Review

 - A bone may need to be more strict when comparing with anothere bone because rigt now different non intersecting measurements are ignored, which means that it they are treated as 0, but maybe it would be better if it just added to the difference. **I think that when comparing if one measurement is not present then it needs to be provided, so penalize it**. Currently it is not penalized.

 - Question to make: How are different same-type bones named? carpal1, carpal2, ... **Because currently it is assumed that a bone has a unique name**.

 - Idea: Add cli command to get information about current atlas to not have to visualize it's files.

 - Maybe An atlas age and gender must be assigned always becausae right now when loadidng an atlas there is a default age and genre defined. (age 15, male)
