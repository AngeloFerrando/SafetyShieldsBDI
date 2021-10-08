// Agent sample_agent in project qrqtqwet

/* Initial beliefs and rules */

ids([]).

opposite(action3, action4).

/* Initial goals */

!start1.
!parallel_plan1.

/* Plans */

+!start1 : true <- !start.

+!start : true & ids(IDs) & not(.member("id1", IDs)) <-
	.print("Case #1");
	!add_id("id1");
	add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	.
+!start : true & ids(IDs) & not(.member("id2", IDs)) <-
	.print("Case #2");
	!add_id("id2");
	add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	update_shield("{ 'shield1' }", action(action3));
	.print("perform action3");
	remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	.
-!start : true <-
	violated("shield1", Cmds);
	reset_violated;
	.print("Failure caused by shield1");
	!toTerms(Cmds, TCmds);
	!restore(TCmds);
	!start.

+!parallel_plan1 : true & ids(IDs) & not(.member("id3", IDs)) <-
	!add_id("id3");
	add_shield("shield2", "G(remove_belief(belief3) -> (!add_belief(belief3) U action4))");
	update_shield("{ 'shield2' }", remove_belief(belief3));
	-belief3;
	update_shield("{ 'shield2' }", action(action4));
	.print("perform action4");
	remove_shield("shield2", "G(remove_belief(belief3) -> (!add_belief(belief3) U action4))");
	.
-!parallel_plan1 : true <-
	violated("shield2", Cmds);
	reset_violated;
	.print("Failure caused by shield2");
	!toTerms(Cmds, TCmds);
	!restore(TCmds);
	!parallel_plan1.

@add_id[atomic]
+!add_id(Id) : ids(IDs) <- -ids(IDs); +ids([Id|IDs]).
//@get_id[atomic]
//+?get_ids(IDs) : ids(IDs).

+!toTerms([], []).
+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).

+!restore([]) : true <- true.
+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).
+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).
+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).
+!restore([_|Cmds]) : true <- !restore(Cmds).


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
