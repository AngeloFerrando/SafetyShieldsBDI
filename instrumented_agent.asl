ids([]).
opposite(action3, action4).
count(0).

!start1.

+!start1 : true <- .time(H, M, S); !plan1; .time(H1, M1, S1); .print("Execution Time: ", (H1*60*60+M1*60+S1)-(H*60*60+M*60+S), " [seconds].").

+!plan1 : count(100) & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & .length(Stack, Depth) & .concat("shield1_id0_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- !push_id(I, IntDD); ids(I, CurrentlyActShields); add_shield(I, "shield1", "G(add_belief(belief4) -> X(action(action3)))"); !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, ThisShieldId).
+!plan1 : count(C) & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & .length(Stack, Depth) & .concat("shield1_id1_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- !push_id(I, IntDD); ids(I, CurrentlyActShields); add_shield(I, "shield1", "G(add_belief(belief4) -> X(action(action3)))"); update_shield(I, CurrentlyActShields, "remove_belief(count(_))"); -count(_); update_shield(I, CurrentlyActShields, "add_belief(count(C+1))"); +count(C+1); update_shield(I, CurrentlyActShields, "add_belief(belief5)"); +belief5; update_shield(I, CurrentlyActShields, "goal(plan2)"); !plan2; update_shield(I, CurrentlyActShields, "action(action3)"); action3; update_shield(I, CurrentlyActShields, "goal(plan1)"); !plan1; !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, ThisShieldId).
-!plan1 : .intention(I, _, Stack, current) & violated(I, "shield1", Cmds) & (count(I, "shield1", Count) | Count = 1) <- -count(I, Count); +count(I, Count+1); !toTerms(Cmds, TCmds); !restore(TCmds); !plan1.
-!plan1 : .intention(I, _, Stack, current) <- !pop_count(I, "shield1", Count, ThisShieldId); remove_shield(I, ThisShieldId).



+!plan2 : true & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & .length(Stack, Depth) & .concat("shield2_id2_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- !push_id(I, IntDD); ids(I, CurrentlyActShields); add_shield(I, "shield2", "G(add_belief(belief4) -> X(action(action3)))"); update_shield(I, CurrentlyActShields, "action(action4)"); action4; !get_count(I, "shield2", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, ThisShieldId).
-!plan2 : .intention(I, _, Stack, current) & violated(I, "shield2", Cmds) & (count(I, "shield2", Count) | Count = 1) <- -count(I, Count); +count(I, Count+1); !toTerms(Cmds, TCmds); !restore(TCmds); !plan2.
-!plan2 : .intention(I, _, Stack, current) <- !pop_count(I, "shield2", Count, ThisShieldId); remove_shield(I, ThisShieldId).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
@push_id[atomic]
+!push_id(Intention, Id) : ids(Intention, IDs) <- -ids(Intention, IDs); +ids(Intention, [Id|IDs]).
+!push_id(Intention, Id) : true <- +ids(Intention, [Id]).

@pop_id[atomic]
+!pop_id(Intention, Id) : ids(Intention, [Id|IDs]) <- -ids(Intention, _); +ids(Intention, IDs).

+!pop_count(Intention, 1, Id) : true <- !pop_id(Intention, Id).
+!pop_count(Intention, N, Id) : true <- !pop_id(Intention, _); !pop_count(Intention, N-1, Id).

+!toTerms([], []).
+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).

+!restore([]) : true <- true.
+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).
+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).
+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).
+!restore([_|Cmds]) : true <- !restore(Cmds).

+!get_count(Intention, Count, Default) : count(Intention, Count).
+!get_count(Intention, Default, Default).
