// Agent sample_agent in project k3

/* Initial beliefs and rules */

fast.
first.

/* Initial goals */

!inspect_nuclear_plant.

/* Plans */

+!inspect_nuclear_plant : first <- -first; !inspect_nuclear_plant.
+!inspect_nuclear_plant : .intend(inspect_nuclear_plant, I1) & .print("Intention1: ", I1)
<- 
	.intention(I, _, _, current);
	.print("Intention2: ", I);
	.fail;
    !inspect(wp1);
    move_to(wp2, R2); -perc_rad(R2); +perc_rad(R2);
    .print("Detected level of radiation: ", R2);
    move_to(wp3, R3); -perc_rad(R3); +perc_rad(R3);
    .print("Detected level of radiation: ", R3);
    !inspect(wp3).
+!inspect_nuclear_plant : true
<- 
	.intention(I, _, _, current);
	.print("Intention: ", I);
    !inspect(wp1);
    move_to(wp4, R4); -perc_rad(R4); +perc_rad(R4);
    .print("Detected level of radiation: ", R4);
    move_to(wp5, R5); -perc_rad(R5); +perc_rad(R5);
    .print("Detected level of radiation: ", R5);
    !inspect(wp5).
-!inspect_nuclear_plant : .intend(inspect_nuclear_plant,I1) & .print("Intention1: ", I1) <-
	.intention(I, _, _, current);
	.print("Intention2: ", I).
+!inspect(WP) : true
<-
	.intention(I, _, _, current);
	.print("Intention: ", I);
    inspect_barrel(WP, Result);
    .print(Result).
 

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
