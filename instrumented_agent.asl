ids([]).
opposite(action3, action4).
count(0).

!start1.

+!start1 : true <- .time(H, M, S); !plan1; .time(H1, M1, S1); .print("Execution Time: ", (H1*60*60+M1*60+S1)-(H*60*60+M*60+S), " [seconds].").

+!plan1 : count(100) & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & (depth(I, Depth)|Depth=0) & .concat("shield1_id0_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield1", IntIDD); ?ids(I, CurrentlyActShields); add_shield(I, "shield1", "G(add_belief(belief4) -> X(action(action3)))"); !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1").
+!plan1 : count(C) & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & (depth(I, Depth)|Depth=0) & .concat("shield1_id1_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield1", IntIDD); ?ids(I, CurrentlyActShields); add_shield(I, "shield1", "G(add_belief(belief4) -> X(action(action3)))"); update_shield(I, CurrentlyActShields, "remove_belief(count(_))"); -count(_); update_shield(I, CurrentlyActShields, "add_belief(count(C+1))"); +count(C+1); update_shield(I, CurrentlyActShields, "add_belief(belief4)"); +belief4; update_shield(I, CurrentlyActShields, "action(action4)"); action4; update_shield(I, CurrentlyActShields, "goal(plan1)"); !plan1; !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1").
+!plan1 : true & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & (depth(I, Depth)|Depth=0) & .concat("shield1_id2_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield1", IntIDD); ?ids(I, CurrentlyActShields); add_shield(I, "shield1", "G(add_belief(belief4) -> X(action(action3)))"); !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1").
-!plan1 : .intention(I, _, Stack, current) & violated(I, "shield1", Cmds) & (count(I, "shield1", Count) | Count = 1) <- !toTerms(Cmds, TCmds); !restore(TCmds); -depth(I, D); +depth(I, D-1); !plan1.
-!plan1 : .intention(I, _, Stack, current) & (count(I, "shield1", Count) | Count = 1) <- !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1"); -depth(I, D); +depth(I, D-1); .fail.



+!plan2 : true & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & (depth(I, Depth)|Depth=0) & .concat("shield2_id3_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield2", IntIDD); ?ids(I, CurrentlyActShields); add_shield(I, "shield2", "G(add_belief(belief4) -> X(action(action3)))"); update_shield(I, CurrentlyActShields, "action(action4)"); action4; !get_count(I, "shield2", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield2").
-!plan2 : .intention(I, _, Stack, current) & violated(I, "shield2", Cmds) & (count(I, "shield2", Count) | Count = 1) <- !toTerms(Cmds, TCmds); !restore(TCmds); -depth(I, D); +depth(I, D-1); !plan2.
-!plan2 : .intention(I, _, Stack, current) & (count(I, "shield2", Count) | Count = 1) <- !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield2"); -depth(I, D); +depth(I, D-1); .fail.



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
@push_id[atomic]
+!push_id(Intention, ShieldId, Id) : ids(Intention, IDs) <- -ids(Intention, IDs); +ids(Intention, [Id|IDs]); -count(Intention, ShieldId, C); +count(Intention, ShieldId, C+1).
+!push_id(Intention, ShieldId, Id) : true <- +ids(Intention, [Id]); -count(Intention, ShieldId, _); +count(Intention, ShieldId, 1).

@pop_id[atomic]
+!pop_id(Intention, Id) : ids(Intention, [Id|IDs]) <- -ids(Intention, _); +ids(Intention, IDs).

@pop_count[atomic]+!pop_count(Intention, 1, Id) : true <- !pop_id(Intention, Id).
+!pop_count(Intention, N, Id) : true <- !pop_id(Intention, _); !pop_count(Intention, N-1, Id).

+!toTerms([], []).
+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).

+!restore([]) : true <- true.
+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).
+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).
+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).
+!restore([_|Cmds]) : true <- !restore(Cmds).

+!get_count(Intention, ShieldId, Count, Default) : count(Intention, ShieldId, Count).
+!get_count(Intention, ShieldId, Default, Default).

