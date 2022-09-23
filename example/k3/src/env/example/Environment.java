package example;

import cartago.*;

public class Environment extends Artifact {
	int currentWP = 0;
	String[] WPs = null;
	String[] radiations = null;
	
	void init(int nWPs) {
		WPs = new String[nWPs];
		radiations = new String[nWPs];
		for(int i = 0; i < nWPs; i++) {
			WPs[i] = "Barrel is OK";
			if(i == 3) {
				radiations[i] = "high";
			} else {
				radiations[i] = "low";
			}
		}
	}

	@OPERATION
	void move_to(String wp, OpFeedbackParam<String> radiation) {
		System.out.println("Moving to " + wp);
		try{ Thread.sleep(1000); } catch(Exception e) {}
		currentWP = Character.getNumericValue(wp.charAt(wp.length()-1));
		System.out.println(currentWP);
		radiation.set(radiations[currentWP]);
	}
	
	@OPERATION
	void inspect_barrel(String wp, OpFeedbackParam<String> result) {
		int i = Character.getNumericValue(wp.charAt(wp.length()-1));
		result.set(WPs[i]);
	}

}

