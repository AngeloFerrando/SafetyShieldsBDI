belief1.
belief2.
belief3.
count(0).

opposite(A, A).

!start.

+!start : true <- .time(H, M, S); !plan0; .time(H1, M1, S1); .print("Execution Time: ", (H1*60*60+M1*60+S1)-(H*60*60+M*60+S), " [seconds].").

+!plan0 : true <- !!plan1; !!plan2; !!plan3; !!plan4; !!plan5; !!plan6; !!plan7; !!plan8; !!plan9; !!plann1; !!plann2; !!plann3; !!plann4; !!plann5; !!plann6; !!plann7; !!plann8; !!plann9; !!plannn1; !!plannn2; !waitAll.
+!waitAll : count(20) <- true.
+!waitAll : true <- .wait(100); !waitAll.

@inc_count[atomic]
+!inc_count : count(C) <- -count(_); +count(C+1).

+belief4 : true <- action5.

@shield1("G(add_belief(belief4) -> X(action(action3)))")
+!plan1 : true <- +belief5; action1; !inc_count.
+!plan1 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield2("G(add_belief(belief4) -> X(action(action3)))")
+!plan2 : true <- +belief5; action1; !inc_count.
+!plan2 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield3("G(add_belief(belief4) -> X(action(action3)))")
+!plan3 : true <- +belief5; action1; !inc_count.
+!plan3 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield4("G(add_belief(belief4) -> X(action(action3)))")
+!plan4 : true <- +belief5; action1; !inc_count.
+!plan4 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield5("G(add_belief(belief4) -> X(action(action3)))")
+!plan5 : true <- +belief5; action1; !inc_count.
+!plan5 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield6("G(add_belief(belief4) -> X(action(action3)))")
+!plan6 : true <- +belief5; action1; !inc_count.
+!plan6 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield7("G(add_belief(belief4) -> X(action(action3)))")
+!plan7 : true <- +belief5; action1; !inc_count.
+!plan7 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield8("G(add_belief(belief4) -> X(action(action3)))")
+!plan8 : true <- +belief5; action1; !inc_count.
+!plan8 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shield9("G(add_belief(belief4) -> X(action(action3)))")
+!plan9 : true <- +belief5; action1; !inc_count.
+!plan9 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd1("G(add_belief(belief4) -> X(action(action3)))")
+!plann1 : true <- +belief5; action1; !inc_count.
+!plann1 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd2("G(add_belief(belief4) -> X(action(action3)))")
+!plann2 : true <- +belief5; action1; !inc_count.
+!plann2 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd3("G(add_belief(belief4) -> X(action(action3)))")
+!plann3 : true <- +belief5; action1; !inc_count.
+!plann3 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd4("G(add_belief(belief4) -> X(action(action3)))")
+!plann4 : true <- +belief5; action1; !inc_count.
+!plann4 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd5("G(add_belief(belief4) -> X(action(action3)))")
+!plann5 : true <- +belief5; action1; !inc_count.
+!plann5 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd6("G(add_belief(belief4) -> X(action(action3)))")
+!plann6 : true <- +belief5; action1; !inc_count.
+!plann6 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd7("G(add_belief(belief4) -> X(action(action3)))")
+!plann7 : true <- +belief5; action1; !inc_count.
+!plann7 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd8("G(add_belief(belief4) -> X(action(action3)))")
+!plann8 : true <- +belief5; action1; !inc_count.
+!plann8 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shieldd9("G(add_belief(belief4) -> X(action(action3)))")
+!plann9 : true <- +belief5; action1; !inc_count.
+!plann9 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shielddd1("G(add_belief(belief4) -> X(action(action3)))")
+!plannn1 : true <- +belief5; action1; !inc_count.
+!plannn1 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.

@shielddd2("G(add_belief(belief4) -> X(action(action3)))")
+!plannn2 : true <- +belief5; action1; !inc_count.
+!plannn2 : belief1 <- -belief1; +belief4; action2; !planB; !inc_count.


+belief1 : true <- action6.

+!planA : belief2 & belief3 <- +belief4; action3.
+!planA : true <- +belief5; action4.

+!planB : true <- action4.


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
