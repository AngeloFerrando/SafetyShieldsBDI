
def extract_plan_info(content, i):
    shielded_plan = {}
    j = content.find(':', i)
    shielded_plan['name'] = content[i:j].strip()
    i = j
    j = content.find('<-', i)
    shielded_plan['ctxt'] = content[i+1:j].strip()
    i = j
    j = content.find('.', i)
    shielded_plan['body'] = []
    for cmd in content[i+2:j].strip().split(';'):
        shielded_plan['body'].append(cmd.strip())
    return shielded_plan

def instrument(filename, content, shielded_plans, shielded_by_definition):
    f = open(filename, 'w')
    skip = False
    id = 0
    for i in range(50):
        f.write('ids({i}, []). depth({i} ,0).'.format(i=i))
    f.write('\n')
    events = set()
    for line in content.split('\n'):
        if line.startswith('@shield'): continue
        if line.startswith('{'): f.write(line + '\n')
        elif line.startswith('+'):
            skip = False
            found = False
            for plan in shielded_plans:
                if line.startswith(plan['name']):
                    found = True
                    initially_defined = [x for x in shielded_by_definition if x['name'] == plan['name']]
                    out, ev = instrument_plan(plan, initially_defined, 'id' + str(id))
                    events = events.union(ev)
                    f.write(out + '\n')
                    shielded_plans.remove(plan)
                    if plan['name'].startswith('+!') and not [x for x in shielded_plans if x['name'] == plan['name']] and initially_defined:
                        f.write(recovery_plan(plan, plan['property'])+'\n\n')
                    id = id + 1
                    skip = True
                    break
            if not found:
                f.write(line + '\n')
        elif not skip:
            f.write(line + '\n')
    evF = open('events.txt', 'w')
    evF.write('[')
    evF.write(','.join(events))
    evF.write(']')
    evF.close()
    f.write('@push_id[atomic]\n')
    f.write('+!push_id(Intention, ShieldId, Id) : ids(Intention, IDs) <- -ids(Intention, IDs); +ids(Intention, [Id|IDs]); -count(Intention, ShieldId, C); +count(Intention, ShieldId, C+1).\n')
    f.write('+!push_id(Intention, ShieldId, Id) : true <- +ids(Intention, [Id]); -count(Intention, ShieldId, _); +count(Intention, ShieldId, 1).\n\n')
    f.write('@pop_id[atomic]\n')
    f.write('+!pop_id(Intention, Id) : ids(Intention, [Id|IDs]) <- -ids(Intention, _); +ids(Intention, IDs).\n\n')
    f.write('@pop_count[atomic]')
    f.write('+!pop_count(Intention, 1, Id) : true <- !pop_id(Intention, Id).\n')
    f.write('+!pop_count(Intention, N, Id) : true <- !pop_id(Intention, _); !pop_count(Intention, N-1, Id).\n\n')
    # f.write('+!remove_ids(ShieldId) : ids(IDs) <- !remove_ids(ShieldId, IDs, IDs1); -ids(_); +ids(IDs1).\n')
    # f.write('+!remove_ids(ShieldId, [], []) : true <- true.\n')
    # f.write('+!remove_ids(ShieldId, [ID|IDs], IDs1) : .substring(ShieldId, ID) <- !remove_ids(ShieldId, IDs, IDs1).\n')
    # f.write('+!remove_ids(ShieldId, [ID|IDs], [ID|IDs1]) : true <- !remove_ids(ShieldId, IDs, IDs1).\n')
    f.write('+!toTerms([], []).\n')
    f.write('+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).\n\n')
    f.write('+!restore([]) : true <- true.\n')
    f.write('+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).\n')
    f.write('+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).\n')
    f.write('+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).\n')
    f.write('+!restore([_|Cmds]) : true <- !restore(Cmds).\n\n')
    f.write('+!get_count(Intention, ShieldId, Count, Default) : count(Intention, ShieldId, Count).\n')
    f.write('+!get_count(Intention, ShieldId, Default, Default).\n\n')
    f.close()
def instrument_plan(plan, initially_defined, id):
    if initially_defined:
        instrumented_plan = plan['name'] + ' : ' + plan['ctxt'] + ' & .intention(I, _, Stack, current) & (ids(I, IDs) | IDs=[]) & (depth(I, Depth)|Depth=0) & .concat("'+plan['id']+'_'+id+'_", Depth, IntIDD) & not(.member(IntIDD, IDs))' + ' <- -depth(I, _); +depth(I, Depth+1); !push_id(I, "'+plan['id']+'", IntIDD); ?ids(I, CurrentlyActShields); '
    else:
        instrumented_plan = plan['name'] + ' : ' + plan['ctxt'] + ' & .intention(I, _, Stack, current) <- ?ids(I, CurrentlyActShields); '
    if 'property' in plan:
        instrumented_plan = instrumented_plan + 'add_shield(I, "'+plan['id']+'", "' + plan['property'] + '"); '
    first = True
    events = set()
    for cmd in plan['body']:
        if first:
            first = False
            #instrumented_plan = instrumented_plan + '?ids(IDsAux); '
        else:
            instrumented_plan = instrumented_plan + '; '
        # shieldIds = set()
        # if 'id' in plan and plan['id']:
        #     shieldIds.add(plan['id'])
        # if 'father_id' in plan and plan['father_id']:
        #     shieldIds = shieldIds.union(plan['father_id'])
        if cmd.startswith('+'):
            instrumented_plan = instrumented_plan + 'update_shield(I, CurrentlyActShields, "add_belief(' + cmd[1:] + ')"); ' + cmd
            events.add("add_belief("+cmd[1:]+")")
        elif cmd.startswith('-'):
            instrumented_plan = instrumented_plan + 'update_shield(I, CurrentlyActShields, "remove_belief(' + cmd[1:] + ')"); ' + cmd
            events.add("remove_belief("+cmd[1:]+")")
        elif cmd.startswith('?'):
            instrumented_plan = instrumented_plan + 'update_shield(I, CurrentlyActShields, "test_goal(' + cmd[1:] + ')"); ' + cmd
            events.add("test_goal("+cmd[1:]+")")
        elif cmd.startswith('!'):
            instrumented_plan = instrumented_plan + 'update_shield(I, CurrentlyActShields, "goal(' + cmd[1:] + ')"); ' + cmd
            events.add("goal("+cmd[1:]+")")
        elif cmd != 'true' and cmd != '':
            instrumented_plan = instrumented_plan + 'update_shield(I, CurrentlyActShields, "action(' + cmd + ')"); ' + cmd
            events.add("action("+cmd+")")
    if 'property' in plan:
        if not instrumented_plan.endswith('; '): instrumented_plan = instrumented_plan + '; '
        instrumented_plan = instrumented_plan + '!get_count(I, "'+plan['id']+'", Count, 1); !pop_count(I, Count, ThisShieldId); remove_shield(I, "'+plan['id']+'")' #'remove_shield(I, "'+plan['id']+'", "' + plan['property'] + '")'
    instrumented_plan = instrumented_plan + '.'
    return instrumented_plan, events
def recovery_plan(plan, property):
    instrumented_plan = '-' + plan['name'][1:] + ' : .intention(I, _, Stack, current) & violated(I, "'+plan['id']+'", Cmds) & (count(I, "'+plan['id']+'", Count) | Count = 1) <- !toTerms(Cmds, TCmds); !restore(TCmds); -depth(I, D); +depth(I, D-1); !' + plan['name'][2:] + '.\n'
    instrumented_plan = instrumented_plan + '-' + plan['name'][1:] + ' : .intention(I, _, Stack, current) & (count(I, "'+plan['id']+'", Count) | Count = 1) <- !pop_count(I, Count, ThisShieldId); remove_shield(I, "'+plan['id']+'"); -depth(I, D); +depth(I, D-1); .fail.\n\n'
    return instrumented_plan

# Update the way we keep track of the shields:
# add a stack of shields for intention (shields_stack(I, [S1,S2,S3]))
# update_shield gets the Ss in the stack and calls the artifact update shield operation
# remove_shield only gets the last S on the stack, remove it, and call the artifact remove shield operation (this is both called at the end of the shielded plan, and in the recovery plan)


f = open('experiment_single.asl', 'r')
content = f.read()

i = content.find('@shield')
j = content.find('("', i)
id = content[i+1:j]
i = j
shielded_plans = []
while i != -1:
    j = content.find('"', i+2)
    property = content[i+2:j].strip()
    i = content.find('+!', i)
    shielded_plan = extract_plan_info(content, i)
    shielded_plan['id'] = id
    shielded_plan['father_id'] = set()
    shielded_plan['property'] = property
    shielded_plans.append(shielded_plan)
    i = content.find(shielded_plan['name'], i+1)
    while i!= -1:
        j = i + 1
        shielded_plan = extract_plan_info(content, i)
        shielded_plan['id'] = id
        shielded_plan['father_id'] = set()
        shielded_plan['property'] = property
        shielded_plans.append(shielded_plan)
        i = content.find(shielded_plan['name'], i+1)
    i = content.find('@shield', j)
    j = content.find('("', i)
    id = content[i+1:j]
    i = j

shielded_by_definition = shielded_plans.copy()
already_seen = set()
for shielded_plan in shielded_plans:
    for cmd in shielded_plan['body']:
        skip = False
        if cmd in already_seen: continue
        else: already_seen.add(cmd)
        for aux in shielded_plans:
            if aux['name'][1:] == cmd:
                aux['father_id'].add(shielded_plan['id'])
                aux['father_id'] = aux['father_id'].union(shielded_plan['father_id'])
                skip = True
        if skip:
            continue
        k = 0
        while True:
            if cmd.startswith('!') or cmd.startswith('?'):
                j = k
                while True:
                    i = content.find('+' + cmd, j)
                    if i != -1 and (content.find(':', i) == -1 or (content.find(':', i) >= content.find(';', i) and content.find(';', i) != -1) or (content.find(':', i) >= content.find('.', i) and content.find('.', i) != -1) or (content.find(':', i) >= content.find('"', i) and content.find('"', i) != -1)):
                        j = i+1
                    else:
                        break
                if i == -1: break
            elif cmd.startswith('+') or cmd.startswith('-'):
                j = k
                while True:
                    i = content.find(cmd, j)
                    if i != -1 and (content.find(':', i) == -1 or (content.find(':', i) >= content.find(';', i) and content.find(';', i) != -1) or (content.find(':', i) >= content.find('.', i) and content.find('.', i) != -1) or (content.find(':', i) >= content.find('"', i) and content.find('"', i) != -1)):
                        j = i+1
                    else:
                        break
                if i == -1: break
            else:
                break
            subplan = extract_plan_info(content, i)
            subplan['father_id'] = set()
            subplan['father_id'].add(shielded_plan['id'])
            shielded_plans.append(subplan)
            k = i + 1

print(shielded_plans)
instrument('instrumented_agent.asl', content, shielded_plans, shielded_by_definition)
