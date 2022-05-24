import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;
import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

public class Monitor {
    private String[] alphabet;
    private HashMap<String, State> states = new HashMap<>();
    private State currentState;
    private Verdict currentVerdict = Verdict.Unknown;
    private String ltl;
    public static String rv;
    private List<MemoryState> past = new ArrayList<>();

    private static class MemoryState {
    	private String event;
    	private State state;
    	
    	public MemoryState(String event, State state) {
			this.event = event;
			this.state = state;
		}
    }
    
    public static void main(String[] args) throws IOException {
        System.out.println(new Monitor(args[0], args[1], args[2]));
    }

    private static class State {
        private String name;
        private HashMap<String, State> transitions = new HashMap<>();
        private Verdict output;
        private State(String name, Verdict output) {
            this.name = name;
            this.output = output;
        }
    }
    public static enum Verdict { True, False, Unknown, GiveUp };

    public String getLtl() {
        return ltl;
    }

    public Verdict getCurrentVerdict() {
        return this.currentVerdict;
    }

    public Monitor(String lamaconvPath, String ltl, String ltlAlphabet) throws IOException {
        this.ltl = "LTL=" + ltl.replace("and", "AND").replace("or", "OR").replace(" ", "");
        String command;
        if(ltlAlphabet != null) {
        	command = "java -jar " + lamaconvPath + "/rltlconv.jar " + this.ltl + ",ALPHABET=" + ltlAlphabet + " --formula --nbas --min --nfas --dfas --min --moore";
        } else {
        	command = "java -jar " + lamaconvPath + "/rltlconv.jar " + this.ltl + " --formula --nbas --min --nfas --dfas --min --moore";
        }
        try(Scanner scanner = new Scanner(Runtime.getRuntime().exec(command).getInputStream()).useDelimiter("\n")) {
            while(scanner.hasNext()) {
                String mooreString = scanner.next();
                if(mooreString.contains("ALPHABET")) {
                    String[] alphabet = mooreString.split("=")[1].trim().replace("[", "").replace("]", "").split(",");
                    this.alphabet = new String[alphabet.length];
                    for(int i = 0; i < alphabet.length; i++) {
                        this.alphabet[i] = alphabet[i].replace("\"", "");
                    }
                } else if(mooreString.contains("STATES")) {
                    for(String state : mooreString.split("=")[1].split(",")) {
                        state = state.trim().replace("[", "").replace("]", "");
                        String name = state.split(":")[0];
                        String verdictStr = state.split(":")[1];
                        Verdict output = verdictStr.equals("true") ? Verdict.True : (verdictStr.equals("false") ? Verdict.False : Verdict.Unknown);
                        this.states.put(name, new State(name, output));
                    }
                } else if(mooreString.contains("START")) {
                    this.currentState = states.get(mooreString.split("=")[1].trim());
                } else if(mooreString.contains("DELTA")) {
                    String[] args = mooreString.substring(mooreString.indexOf("(")+1, mooreString.indexOf(")")).split(",");
                    this.states.get(args[0].trim()).transitions.put(args[1].trim().replace("\"", ""), states.get(mooreString.split("=")[1].trim()));
                }
            }
        }
        this.itIsOkToGiveUp();
    }

    @Override
    public String toString() {
        String res = "MOORE {\n";
        if(this.alphabet != null) {
        	res += "\tALPHABET = [" + String.join(", ", this.alphabet) + "]\n";
        }
        res += "\tSTATES = [";
        boolean first = true;
        for(Map.Entry<String, State> entry : this.states.entrySet()) {
            if(first) { first = false; }
            else { res += ", "; }
            res += entry.getKey() + ":" + (entry.getValue().output == Verdict.True ? "true" : (entry.getValue().output == Verdict.False ? "false" : (entry.getValue().output == Verdict.Unknown ? "?" : "x")));
        }
        res += "]\n";
        res += "\tSTART = " + this.currentState.name + "\n";
        for(Map.Entry<String, State> entry1 : this.states.entrySet()) {
            for(Map.Entry<String, State> entry2 : entry1.getValue().transitions.entrySet()) {
                res += "\tDELTA(" + entry1.getKey() + ", " + entry2.getKey() + ") = " + entry2.getValue().name + "\n";
            }
        }
        res += "}";
        return res;
    }

    private void itIsOkToGiveUp() {
        for(Map.Entry<String, State> entry : this.states.entrySet()) {
            if(entry.getValue().output == Verdict.Unknown && !canReachFinalVerdictState(entry.getValue())) {
                entry.getValue().output = Verdict.GiveUp;
            }
        }
    }

    private boolean canReachFinalVerdictState(State state) {
        Set<String> visited = new HashSet<String>();
        return canReachFinalVerdictStateAux(state, visited);
    }

    private boolean canReachFinalVerdictStateAux(State state, Set<String> visited) {
        if(visited.contains(state.name)) {
            return false;
        } else {
            visited.add(state.name);
            if(state.output == Verdict.True || state.output == Verdict.False) {
                return true;
            }
            for(Map.Entry<String, State> entry : state.transitions.entrySet()) {
                if(canReachFinalVerdictStateAux(entry.getValue(), visited)) {
                    return true;
                }
            }
            return false;
        }
    }

    public Verdict next(String event) {
        event = event.toLowerCase();
        MemoryState memState = new MemoryState(event, currentState);
        past.add(memState);
        try {
			Thread.sleep(10);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        if(currentState.transitions.containsKey(event)) {
//        	System.out.println("inside");
            currentState = currentState.transitions.get(event);
            currentVerdict = currentState.output;
            return currentVerdict;
        } else if(currentState.transitions.containsKey("?")) {
            currentState = currentState.transitions.get("?");
            currentVerdict = currentState.output;
            return currentVerdict;
        }
        return currentVerdict;
    }
    
    public List<String> back() {
    	return this.back(past.size());
    }
    
    public List<String> back(int steps) {
    	List<String> events = new ArrayList<String>();
    	for(int i = 0; i < steps; i++) {
    		if(i == steps-1) {
    			this.currentState = past.get(past.size() - 1).state;
    		}
    		events.add(past.get(past.size() - 1).event);
    		past.remove(past.size() - 1);
    	}
    	return events;
    }
}
