:-module(source_link,[]).

%this makes sure bagof produces shared variables!
attr_unify_hook(Source_link,Variable):-get_attr(Variable,source_link,Variable_source_link),Source_link=Variable_source_link.