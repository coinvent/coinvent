:-module(place,[]).

attr_unify_hook(Place,Variable):-get_attr(Variable,place,Variable_Place),Variable_Place==Place.