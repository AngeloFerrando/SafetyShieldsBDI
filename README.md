# SafetyShieldsBDI

## Instrumentation

The instrument.py file contains the code for instrumenting a BDI agent implemented in Jason. To test, just run it in the terminal.
To set the name of the .asl file to instrument, change line 125.

## JaCaMo

Inside the example folder, a JaCaMo abstract example can be found. There, four types of agents have been implemented. One with a single shielded plan, another with nested shielded plans, and finally, one with parallel shielded plans.
Moreover, an abstract agent can be found. This has been used as skeleton for the experiments carried out in the paper.
The result obtained from the instrumentation process has to be pasted inside the abstract_agent.asl to be executed in JaCaMo.
Inside the env/ folder we can instead find the artifact handling the shields. Such artifact is already defined and focused by the abstract agent in the .jcm file.
To run JaCaMo, install the Eclipse plugin and then open the project. Once there, click "Run JaCaMo Application"
