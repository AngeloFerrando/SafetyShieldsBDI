ids([]).
opposite(action3, action4).
count(0).

!start1.

+!start1 : true <- .time(H, M, S); !plan1; .time(H1, M1, S1); .print("Execution Time: ", (H1*60*60+M1*60+S1)-(H*60*60+M*60+S), " [seconds].").

+!plan1 : count(100) & ids(IDs) & not(.member("shield1_id0", IDs)) <- !add_id("shield1_id0"); add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))"); remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))"); !remove_ids("shield1_id0").
+!plan1 : count(C) & ids(IDs) & not(.member("shield1_id1", IDs)) <- !add_id("shield1_id1"); add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))"); update_shield("{'shield1'}", "remove_belief(count(_))"); -count(_); update_shield("{'shield1'}", "add_belief(count(C+1))"); +count(C+1); update_shield("{'shield1'}", "add_belief(belief5)"); +belief5; update_shield("{'shield1'}", "goal(plan2)"); !plan2; update_shield("{'shield1'}", "action(action3)"); action3; update_shield("{'shield1'}", "goal(plan1)"); !plan1; remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))"); !remove_ids("shield1_id1").
-!plan1 : true <- violated("shield1", Cmds); !toTerms(Cmds, TCmds); !restore(TCmds); !plan1.

+!plan2 : true & ids(IDs) & not(.member("shield2_id2", IDs)) <- !add_id("shield2_id2"); add_shield("shield2", "G(add_belief(belief4) -> X(action(action3)))"); update_shield("{'shield2', 'shield1'}", "action(action4)"); action4; remove_shield("shield2", "G(add_belief(belief4) -> X(action(action3)))"); !remove_ids("shield2_id2").
-!plan2 : true <- violated("shield2", Cmds); !toTerms(Cmds, TCmds); !restore(TCmds); !plan2.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
@add_id[atomic]
+!add_id(Id) : ids(IDs) <- -ids(IDs); +ids([Id|IDs]).

@remove_ids[atomic]
+!remove_ids(ShieldId) : ids(IDs) <- !remove_ids(ShieldId, IDs, IDs1); -ids(_); +ids(IDs1).
+!remove_ids(ShieldId, [], []) : true <- true.
+!remove_ids(ShieldId, [ID|IDs], IDs1) : .substring(ShieldId, ID) <- !remove_ids(ShieldId, IDs, IDs1).
+!remove_ids(ShieldId, [ID|IDs], [ID|IDs1]) : true <- !remove_ids(ShieldId, IDs, IDs1).
+!toTerms([], []).
+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).

+!restore([]) : true <- true.
+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).
+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).
+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).
+!restore([_|Cmds]) : true <- !restore(Cmds).
