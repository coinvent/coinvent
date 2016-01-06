% import unify_hooks needed for attributed variable unification
:- use_module(unify_hooks(source)).
:- use_module(unify_hooks(type)).
:- use_module(unify_hooks(name)).
:- use_module(unify_hooks(place)).
:- use_module(unify_hooks(sort_link)).
:- use_module(unify_hooks(var_link)).
:- use_module(unify_hooks(reverse_link)).
:- use_module(unify_hooks(source_link)).
:- use_module(unify_hooks(target_link)).
:- use_module(unify_hooks(general_link)).
:- use_module(unify_hooks(parent_link)).
:- use_module(unify_hooks(subst_p)).
:- use_module(unify_hooks(subst_i)).
:- use_module(unify_hooks(subst_e)).
:- use_module(unify_hooks(subst_f)).
:- use_module(unify_hooks(mode_p)).
:- use_module(unify_hooks(mode_e)).
:- use_module(unify_hooks(mode_i)).
:- use_module(unify_hooks(mode_f)).
:- use_module(unify_hooks(cost_p)).
:- use_module(unify_hooks(cost_e)).
:- use_module(unify_hooks(cost_i)).
:- use_module(unify_hooks(cost_f)).
:- use_module(unify_hooks(number_predicates)).
:- use_module(unify_hooks(sig)).


% import modules and make specific predicates available in user namespace
:- use_module(modules(configure)).
:- use_module(modules(main)).
:- use_module(modules(subst_preload)).
:- use_module(modules(struct)).
:- use_module(modules(unstruct)).
:- use_module(modules(print)).
:- use_module(modules(higherau)).
:- use_module(modules(linking)).
:- use_module(modules(subst_inline)).
:- use_module(modules(loader)).
:- use_module(modules(utilities)).
:- use_module(modules(transfer)).
:- use_module(modules(mapping)).
:- use_module(modules(sorts)).
:- use_module(modules(casl_parser)).