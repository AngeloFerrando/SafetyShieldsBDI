// Internal action code for project icnp.mas2j

package shield;

import jason.*;
import jason.asSemantics.*;
import jason.asSyntax.*;

import org.jpl7.Query;

import java.util.List;

public class initialize extends DefaultInternalAction {

  @Override
  public Object execute(TransitionSystem ts, Unifier un, Term[] args) throws Exception {
    JPLUtils.init();

    // execute the internal action
    if(args.length != 2){
      throw new JasonException("initialize/2: Needs 2 arguments");
    }

    if(args[0] == null || args[1] == null || args[0].isVar() ||
        args[1].isVar() || !args[0].isString() || !args[1].isList()){
      throw new JasonException("initialize/2: Invalid arguments");
    }

    List<Term> agents = ((ListTerm) args[1]).getAsList();
    String agentsS = "[";
    for(int i = 0; i < agents.size(); i++){
      agentsS += agents.get(i).toString();
      if(i < agents.size() - 1){
        agentsS += ",";
      }
    }
    agentsS += "]";

    Query query = new Query("initialize(" + args[0] + ", " + agentsS + ")");
    return query.hasSolution();
  }
}
