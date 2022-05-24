opposite(action3, action4).
count(0).

!start1.

+!start1 : true <- .time(H, M, S); !plan1; .time(H1, M1, S1); .print("Execution Time: ", (H1*60*60+M1*60+S1)-(H*60*60+M*60+S), " [seconds].").

@shield1("G(add_belief(belief4) -> X(action(action3)))")
+!plan1 : count(100) <- true.
+!plan1 : count(C) <- -count(_); +count(C+1); +belief4; action4; !plan1.
+!plan1 : true <- .print("terminated").

@shield2("G(add_belief(belief4) -> X(action(action3)))")
+!plan2 : true <- action4.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
