// CArtAgO artifact code for project SafetyShieldBDI
package shield;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
	}
	
	@OPERATION
	void add_shield(int intention, String id, String property, Object[] events) throws IOException {
		property = property.replace("_", "");
//		property = property.replaceAll("(\\S+)\\((\\S+)\\)", "$1$2");
		property = property.replace("(", "").replace(")", "").replace("\"", "");
		property = property.strip();
		String ltlAlphabet = "[";
		boolean first = true;
		for(Object o : events) {
			if(first) {
				first = false;
			} else {
				ltlAlphabet = ltlAlphabet + ",";
			}
			ltlAlphabet = ltlAlphabet + o.toString().replace("_", "").replace("(", "").replace(")", "").replace("\"", "");
		}
		ltlAlphabet = ltlAlphabet + "]";
		shields.putIfAbsent(intention+id, new Monitor(lamaconvPath, property, ltlAlphabet));
		System.out.println("Intention" + intention + "Shield " + id + " has been added.");
	}

	@OPERATION
	void remove_shield(int intention, String id) {
		if(id.contains("_")) {
			shields.remove(intention+id.substring(0, id.indexOf("_")));
		} else {
			shields.remove(intention+id);
		}
		System.out.println("Intention" + intention + "Shield " + id + " has been removed.");
	}

	@OPERATION
	void update_shield(int intention, Object[] shieldIds, String event) {
		event = event.replace("(", "").replace(")", "").replace("_", "").replace("\"", "");
		System.out.println("------------");
		Set<String> shieldIdsStr = new HashSet<>();
		for(Object k : shieldIds) {
			String key = (String) k;
			shieldIdsStr.add(key.substring(0, key.indexOf("_")).strip());
		}
		for(String key : shieldIdsStr) { //}.replace("{", "").replace("}", "").replace("'", "").strip().split(",")) {
			//System.out.println("Intention" + intention + key);
			//key = key.substring(0, key.indexOf("_"));
			//key = key.strip();
			String shieldId = key;
			key = intention + key;
			Monitor.Verdict result = shields.get(key).next(event);
//			System.out.println(event);
//			System.out.println(shields.get(key));
			if(result == Monitor.Verdict.False) {	
				System.out.println(event);
				System.out.println(shields.get(key));
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
				System.out.println(event);
				System.out.println(shields.get(key));
				this.violatedShield.put(key, cmds);
				defineObsProperty("violated", intention, shieldId, cmds.toArray(new Literal[0]));
				signal("tick");
				//this.cmds = cmds;
				// fail
				System.out.println("Shield has been violated");
				failed("Shield has been violated");
			}
		}
	}
	
//	@OPERATION
//	boolean violated(int intention, String shieldId) {
//		System.out.println("TEST1");
//		return true;
//	}
//
//	@OPERATION
//	void violated(int intention, String shieldId, OpFeedbackParam<Literal[]> cmds) {
//		System.out.println("TEST");
//		if(this.violatedShield.containsKey(intention + shieldId)) {//this.violatedShield != null && this.cmds != null) {
//			//if(!this.violatedShield.equals(shieldId)) {
//			//}
//			cmds.set(this.violatedShield.get(intention + shieldId).toArray(new Literal[this.violatedShield.get(intention + shieldId).size()]));
//			this.violatedShield.remove(intention + shieldId);
//		} else {
//			failed("Not this recovery plan");
//			//failed("");
//		}
//	}

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
