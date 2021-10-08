// Agent sample_agent in project qrqtqwet

/* Initial beliefs and rules */

ids([]).

opposite(action3, action4).

/* Initial goals */

!start1.

/* Plans */

+!start1 : true <- !start.

+!start : true & ids(IDs) & not(.member("id1", IDs)) <- 
	.print("Case #1");
	-ids(IDs); +ids(["id1"|IDs]);
	add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	.
+!start : true & ids(IDs) & not(.member("id2", IDs)) <-
	.print("Case #2");
	-ids(IDs); +ids(["id2"|IDs]);
	add_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	update_shield("{ 'shield1' }", add_belief(belief4));
	+belief4;
	update_shield("{ 'shield1' }", action(action3));
	+belief4;
	remove_shield("shield1", "G(add_belief(belief4) -> X(action(action3)))");
	.
-!start : true <- 
	.print("Failure caused by shield1");
	violated("shield1", Cmds); 
	!toTerms(Cmds, TCmds);
	!restore(TCmds);
	!start.


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
