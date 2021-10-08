
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
    f.write('ids([]).\n')
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
                    f.write(instrument_plan(plan, initially_defined, 'id' + str(id))+'\n')
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
    f.write('@add_id[atomic]\n')
    f.write('+!add_id(Id) : ids(IDs) <- -ids(IDs); +ids([Id|IDs]).\n\n')
    f.write('@remove_ids[atomic]\n')
    f.write('+!remove_ids(ShieldId) : ids(IDs) <- !remove_ids(ShieldId, IDs, IDs1); -ids(_); +ids(IDs1).\n')
    f.write('+!remove_ids(ShieldId, [], []) : true <- true.\n')
    f.write('+!remove_ids(ShieldId, [ID|IDs], IDs1) : .substring(ShieldId, ID) <- !remove_ids(ShieldId, IDs, IDs1).\n')
    f.write('+!remove_ids(ShieldId, [ID|IDs], [ID|IDs1]) : true <- !remove_ids(ShieldId, IDs, IDs1).\n')
    f.write('+!toTerms([], []).\n')
    f.write('+!toTerms([S|Ss], [T|Ts]) <- .term2string(T, S); !toTerms(Ss, Ts).\n\n')
    f.write('+!restore([]) : true <- true.\n')
    f.write('+!restore([add_belief(B)|Cmds]) : true <- -B; !restore(Cmds).\n')
    f.write('+!restore([remove_belief(B)|Cmds]) : true <- +B; !restore(Cmds).\n')
    f.write('+!restore([action(A)|Cmds]) : opposite(A, OpA) <- OpA; !restore(Cmds).\n')
    f.write('+!restore([_|Cmds]) : true <- !restore(Cmds).\n')
    f.close()
def instrument_plan(plan, initially_defined, id):
    if initially_defined:
        instrumented_plan = plan['name'] + ' : ' + plan['ctxt'] + ' & ids(IDs) & not(.member("' + plan['id'] + '_' + id + '", IDs))' + ' <- !add_id("' + plan['id'] + '_' + id + '"); '
    else:
        instrumented_plan = plan['name'] + ' : ' + plan['ctxt'] + ' <- '
    if 'property' in plan:
        instrumented_plan = instrumented_plan + 'add_shield("' + str(plan['id']) + '", "' + plan['property'] + '"); '
    first = True
    for cmd in plan['body']:
        if first: first = False
        else: instrumented_plan = instrumented_plan + '; '
        shieldIds = set()
        if 'id' in plan and plan['id']:
            shieldIds.add(plan['id'])
        if 'father_id' in plan and plan['father_id']:
            shieldIds = shieldIds.union(plan['father_id'])
        if cmd.startswith('+'):
            instrumented_plan = instrumented_plan + 'update_shield("' + str(shieldIds) + '", "add_belief(' + cmd[1:] + ')"); ' + cmd
        elif cmd.startswith('-'):
            instrumented_plan = instrumented_plan + 'update_shield("' + str(shieldIds) + '", "remove_belief(' + cmd[1:] + ')"); ' + cmd
        elif cmd.startswith('?'):
            instrumented_plan = instrumented_plan + 'update_shield("' + str(shieldIds) + '", "test_goal(' + cmd[1:] + ')"); ' + cmd
        elif cmd.startswith('!'):
            instrumented_plan = instrumented_plan + 'update_shield("' +str(shieldIds) + '", "goal(' + cmd[1:] + ')"); ' + cmd
        elif cmd != 'true':
            instrumented_plan = instrumented_plan + 'update_shield("' + str(shieldIds) + '", "action(' + cmd + ')"); ' + cmd
    if 'property' in plan:
        if not instrumented_plan.endswith('; '): instrumented_plan = instrumented_plan + '; '
        instrumented_plan = instrumented_plan + 'remove_shield("' + str(plan['id']) + '", "' + plan['property'] + '")'
        instrumented_plan = instrumented_plan + '; !remove_ids("' + str(plan['id']) + '_' + id + '")'
    instrumented_plan = instrumented_plan + '.'
    return instrumented_plan
def recovery_plan(plan, property):
    instrumented_plan = '-' + plan['name'][1:] + ' : true <- violated("' + plan['id'] + '", Cmds); !toTerms(Cmds, TCmds); !restore(TCmds); !' + plan['name'][2:] + '.'
    return instrumented_plan


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
