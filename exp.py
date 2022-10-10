import sys

for i in range(0, int(sys.argv[1])):
    print('''
@shield{i}("G(add_belief(perc_rad{i}(low)))", ["add_belief(perc_rad{i}(low))", "add_belief(perc_rad{i}(high))"])
+!inspect_nuclear_plant{i} : fast
<-
    !inspect(wp1);
    move_to(wp2, R2); -perc_rad(R2); +perc_rad(R2);
    .print("Detected level of radiation: ", R2);
    move_to(wp3, R3); -perc_rad(R3); +perc_rad(R3);
    .print("Detected level of radiation: ", R3);
    !inspect(wp3).
+!inspect_nuclear_plant{i} : true
<-
    !inspect(wp1);
    move_to(wp4, R4); -perc_rad(R4); +perc_rad(R4);
    .print("Detected level of radiation: ", R4);
    move_to(wp5, R5); -perc_rad(R5); +perc_rad(R5);
    .print("Detected level of radiation: ", R5);
    !inspect(wp3).
'''.format(i=i))
