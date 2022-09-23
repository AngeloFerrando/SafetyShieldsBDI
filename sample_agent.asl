// Agent sample_agent in project k3

/* Initial beliefs and rules */

fast.

/* Initial goals */

!inspect_nuclear_plant.

/* Plans */

@shield1("G(add_belief(perc_rad(low)))")
+!inspect_nuclear_plant : fast
<-
    !inspect(wp1);
    move_to(wp2, R2); -perc_rad(R2); +perc_rad(R2);
    .print("Detected level of radiation: ", R2);
    move_to(wp3, R3); -perc_rad(R3); +perc_rad(R3);
    .print("Detected level of radiation: ", R3);
    !inspect(wp3).
+!inspect_nuclear_plant : true
<-
    !inspect(wp1);
    move_to(wp4, R4); -perc_rad(R4); +perc_rad(R4);
    .print("Detected level of radiation: ", R4);
    move_to(wp5, R5); -perc_rad(R5); +perc_rad(R5);
    .print("Detected level of radiation: ", R5);
    !inspect(wp3).
+!inspect(WP) : true
<-
    inspect_barrel(WP, Result);
    .print(Result).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }
