from statistics import NormalDist
import sys
import json
import random
values=[]

for iteration in json.loads(open(sys.argv[1]).read()):
    value = 0
    for task in iteration['tasks']:
        value += NormalDist(mu = task['mean'], sigma = task['stdr_dev']).inv_cdf(task['prob'])
    values.append(str(value))

print (','.join(values))
