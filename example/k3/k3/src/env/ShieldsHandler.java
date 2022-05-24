// CArtAgO artifact code for project SafetyShieldBDI


import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.bb.BeliefBase;

public class ShieldsHandler extends Artifact {
	String lamaconvPath;
	Map<String, Monitor> shields = new HashMap<>();
	Map<String, List<Literal>> violatedShield = new HashMap<>();
	//List<Literal> cmds;

	void init(String lamaconvPath) {
		this.lamaconvPath = lamaconvPath;
		defineObsProperty("violated", -1, "", null);
	}

	@OPERATION
	void add_shield(Byte intention, String id, String property) throws IOException {
		System.out.println("add_shield has been called");
		property = property.replace("_", "");
		property = property.replaceAll("(\\S+)\\((\\S+)\\)", "$1$2");
		property = property.strip();
		String alphabet = Files.readString(Paths.get("events.txt")).replace("+", "plus").replace("-","minus").replace("(", "").replace(")", "").replace("_", "").toLowerCase(Locale.ROOT);
		if(shields.containsKey(intention+id)) {
			System.out.println("Nested call, the shield is not added again.");
		} else {
			System.out.println("Intention " + intention + " Shield " + id + " has been added.");
		}
		shields.putIfAbsent(intention+id, new Monitor(lamaconvPath, property, alphabet));
	}

	@OPERATION
	void remove_shield(Byte intention, String id) {
//		System.out.println(intention+id);
		shields.remove(intention+id);//.substring(0, id.indexOf("_")));
		System.out.println("Intention " + intention + " Shield " + id + " has been removed.");
	}

	@OPERATION
	void update_shield(Byte intention, Object[] shieldIds, String event) {
		event = event.replace("(", "").replace(")", "").replace("_", "").toLowerCase(Locale.ROOT);
		System.out.println("------------");
		Set<String> shieldIdsStr = new HashSet<>();
		for(Object k : shieldIds) {
//			OpFeedbackParam<String> key = (OpFeedbackParam<String>) k;
			String key = (String) k;
			shieldIdsStr.add(key.substring(0, key.indexOf("_")).strip());
		}
		System.out.println("Active Shields: " + shieldIdsStr);
		System.out.println("event: " + event);
		for(String key : shieldIdsStr) { //}.replace("{", "").replace("}", "").replace("'", "").strip().split(",")) {
			//System.out.println("Intention" + intention + key);
			//key = key.substring(0, key.indexOf("_"));
			//key = key.strip();
			String keyAux = key;
			key = intention + key;
			Monitor.Verdict result = shields.get(key).next(event);
			System.out.println(result);
			if(result == Monitor.Verdict.False) {
				String property = shields.get(key).getLtl();
				property = property.replaceAll("addbelief(\\w+)", "add_belief\\($1\\)");
				property = property.replaceAll("removebelief(\\w+)", "remove_belief\\($1\\)");
				property = property.replaceAll("testgoal(\\w+)", "test_goal\\($1\\)");
				property = property.replaceAll("goal(\\w+)", "goal\\($1\\)");
				property = property.replaceAll("action(\\w+)", "action\\($1\\)");
				List<Literal> cmds = new ArrayList<Literal>();
				for(String cmd :  shields.get(key).back()) {
					cmd = cmd.replaceAll("addbelief(\\w+)", "add_belief\\($1\\)");
					cmd = cmd.replaceAll("removebelief(\\w+)", "remove_belief\\($1\\)");
					cmd = cmd.replaceAll("testgoal(\\w+)", "test_goal\\($1\\)");
					cmd = cmd.replaceAll("goal(\\w+)", "goal\\($1\\)");
					cmd = cmd.replaceAll("action(\\w+)", "action\\($1\\)");
					cmds.add(ASSyntax.createLiteral(cmd));
				}
				System.out.println(cmds);
				this.violatedShield.put(key, cmds);
				System.out.println(this.violatedShield);
				ObsProperty prop = getObsProperty("violated");
				prop.updateValue(0, intention);
				prop.updateValue(1, keyAux);
				prop.updateValue(2, cmds.toArray(new Literal[0]));
				signal("tick");
				//this.cmds = cmds;
				// fail
				failed("Shield has been violated");
			}
		}
	}

	@OPERATION
	void violated(Byte intention, String shieldId, OpFeedbackParam<Literal[]> cmds) {
		if(this.violatedShield.containsKey(intention + shieldId)) {//this.violatedShield != null && this.cmds != null) {
			//if(!this.violatedShield.equals(shieldId)) {
			//}
			System.out.println("violated has been added to the agent's belief base");
			cmds.set(this.violatedShield.get(intention + shieldId).toArray(new Literal[this.violatedShield.get(intention + shieldId).size()]));
			this.violatedShield.remove(intention + shieldId);
		} else {
			failed("Not this recovery plan");
			//failed("");
		}
	}

	@OPERATION
	void reset_violated() {
		this.violatedShield.clear();
		// this.cmds = null;
	}

	@OPERATION
	void action1() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action2() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action3() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action4() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action5() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action6() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action7() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	@OPERATION
	void action8() {
		try {
			Thread.sleep(500);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

//	@OPERATION
//	void violated(OpFeedbackParam<String> shieldId, OpFeedbackParam<String[]> cmds) {
//		if(this.violatedShield != null && this.cmds != null) {
//			shieldId.set(this.violatedShield);
//			cmds.set(Arrays.copyOf(this.cmds.toArray(), this.cmds.size(), String[].class));
//			System.out.println(shieldId);
//		}
//	}
}
