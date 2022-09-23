events(["add_belief(perc_rad(low))", "add_belief(perc_rad(high))"]).
ids(0, []). depth(0, 0).
ids(1, []). depth(1, 0).
ids(2, []). depth(2, 0).
ids(3, []). depth(3, 0).
ids(4, []). depth(4, 0).
ids(5, []). depth(5, 0).
ids(6, []). depth(6, 0).
ids(7, []). depth(7, 0).
ids(8, []). depth(8, 0).
ids(9, []). depth(9, 0).
ids(10, []). depth(10, 0).
ids(11, []). depth(11, 0).
ids(12, []). depth(12, 0).
ids(13, []). depth(13, 0).
ids(14, []). depth(14, 0).
ids(15, []). depth(15, 0).
ids(16, []). depth(16, 0).
ids(17, []). depth(17, 0).
ids(18, []). depth(18, 0).
ids(19, []). depth(19, 0).
ids(20, []). depth(20, 0).
ids(21, []). depth(21, 0).
ids(22, []). depth(22, 0).
ids(23, []). depth(23, 0).
ids(24, []). depth(24, 0).
ids(25, []). depth(25, 0).
ids(26, []). depth(26, 0).
ids(27, []). depth(27, 0).
ids(28, []). depth(28, 0).
ids(29, []). depth(29, 0).
ids(30, []). depth(30, 0).
ids(31, []). depth(31, 0).
ids(32, []). depth(32, 0).
ids(33, []). depth(33, 0).
ids(34, []). depth(34, 0).
ids(35, []). depth(35, 0).
ids(36, []). depth(36, 0).
ids(37, []). depth(37, 0).
ids(38, []). depth(38, 0).
ids(39, []). depth(39, 0).
ids(40, []). depth(40, 0).
ids(41, []). depth(41, 0).
ids(42, []). depth(42, 0).
ids(43, []). depth(43, 0).
ids(44, []). depth(44, 0).
ids(45, []). depth(45, 0).
ids(46, []). depth(46, 0).
ids(47, []). depth(47, 0).
ids(48, []). depth(48, 0).
ids(49, []). depth(49, 0).

/* Initial beliefs and rules */

fast.

/* Initial goals */

!inspect_nuclear_plant.

/* Plans */

+!inspect_nuclear_plant : fast & .intention(I1, _, Stack, current) & (head_intention(I1, I) | (not(head_intention(I1, _)) & I=I1)) & (ids(I, IDs) | (not(ids(I, _)) & IDs=[])) & (depth(I, Depth)|(not(depth(I, _)) & Depth=0)) & .concat("shield1_id0_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield1", IntIDD); ?ids(I, CurrentlyActShields); ?events(Events); add_shield(I, "shield1", "G(add_belief(perc_rad(low)))", Events); .term2string(goal(inspect(wp1)), Term0); update_shield(I, CurrentlyActShields, Term0); !inspect(wp1); 
	.term2string(action(move_to(wp2, R2)), Term1); update_shield(I, CurrentlyActShields, Term1); move_to(wp2, R2); 
	.term2string(remove_belief(perc_rad(R2)), Term2); update_shield(I, CurrentlyActShields, Term2); -perc_rad(R2); 
	.term2string(add_belief(perc_rad(R2)), Term3); update_shield(I, CurrentlyActShields, Term3); +perc_rad(R2); 
	.term2string(action(.print("Detected level of radiation: ", R2)), Term4); update_shield(I, CurrentlyActShields, Term4); .print("Detected level of radiation: ", R2); 
	.term2string(action(move_to(wp3, R3)), Term5); update_shield(I, CurrentlyActShields, Term5); move_to(wp3, R3); 
	.term2string(remove_belief(perc_rad(R3)), Term6); update_shield(I, CurrentlyActShields, Term6); -perc_rad(R3); 
	.term2string(add_belief(perc_rad(R3)), Term7); update_shield(I, CurrentlyActShields, Term7); +perc_rad(R3); 
	.term2string(action(.print("Detected level of radiation: ", R3)), Term8); update_shield(I, CurrentlyActShields, Term8); .print("Detected level of radiation: ", R3); 
	.term2string(goal(inspect(wp3)), Term9); update_shield(I, CurrentlyActShields, Term9); !inspect(wp3); !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1").
+!inspect_nuclear_plant : true & .intention(I1, _, Stack, current) & (head_intention(I1, I) | (not(head_intention(I1, _)) & I=I1)) & (ids(I, IDs) | (not(ids(I, _)) & IDs=[])) & (depth(I, Depth)|(not(depth(I, _)) & Depth=0)) & .concat("shield1_id1_", Depth, IntIDD) & not(.member(IntIDD, IDs)) <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "shield1", IntIDD); ?ids(I, CurrentlyActShields); ?events(Events); add_shield(I, "shield1", "G(add_belief(perc_rad(low)))", Events); .term2string(goal(inspect(wp1)), Term0); update_shield(I, CurrentlyActShields, Term0); !inspect(wp1); 
	.term2string(action(move_to(wp4, R4)), Term1); update_shield(I, CurrentlyActShields, Term1); move_to(wp4, R4); 
	.term2string(remove_belief(perc_rad(R4)), Term2); update_shield(I, CurrentlyActShields, Term2); -perc_rad(R4); 
	.term2string(add_belief(perc_rad(R4)), Term3); update_shield(I, CurrentlyActShields, Term3); +perc_rad(R4); 
	.term2string(action(.print("Detected level of radiation: ", R4)), Term4); update_shield(I, CurrentlyActShields, Term4); .print("Detected level of radiation: ", R4); 
	.term2string(action(move_to(wp5, R5)), Term5); update_shield(I, CurrentlyActShields, Term5); move_to(wp5, R5); 
	.term2string(remove_belief(perc_rad(R5)), Term6); update_shield(I, CurrentlyActShields, Term6); -perc_rad(R5); 
	.term2string(add_belief(perc_rad(R5)), Term7); update_shield(I, CurrentlyActShields, Term7); +perc_rad(R5); 
	.term2string(action(.print("Detected level of radiation: ", R5)), Term8); update_shield(I, CurrentlyActShields, Term8); .print("Detected level of radiation: ", R5); 
	.term2string(goal(inspect(wp3)), Term9); update_shield(I, CurrentlyActShields, Term9); !inspect(wp3); !get_count(I, "shield1", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1").
-!inspect_nuclear_plant : .intention(I1, _, Stack, current) & violated(I, "shield1", Cmds) & (count(I, "shield1", Count) | (not(count(I, "shield1", Count)) & Count = 1)) <- I2 = I1-1; -head_intention(I2, _); +head_intention(I2, I); !toTerms(Cmds, TCmds); !restore(TCmds); -depth(I, D); +depth(I, D-1); !inspect_nuclear_plant.
-!inspect_nuclear_plant : .intention(I, _, Stack, current) & (count(I, "shield1", Count) | Count = 1) <- !pop_count(I, Count, ThisShieldId); remove_shield(I, "shield1"); -depth(I, D); +depth(I, D-1); .fail.



+!inspect(WP) : true
<-
    inspect_barrel(WP, Result);
    .print(Result).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }

@push_id[atomic]
+!push_id(Intention, ShieldId, Id) : ids(Intention, IDs) & (count(Intention, ShieldId, C) | (not(count(Intention, ShieldId, C)) & C=0)) <- -ids(Intention, IDs); +ids(Intention, [Id|IDs]); -count(Intention, ShieldId, C); +count(Intention, ShieldId, C+1).
+!push_id(Intention, ShieldId, Id) : (count(Intention, ShieldId, C) | (not(count(Intention, ShieldId, C)) & C=0)) <- +ids(Intention, [Id]); -count(Intention, ShieldId, _); +count(Intention, ShieldId, 1).

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

