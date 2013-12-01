import networkx as nx
import random

def getNeighborhood(G, u):
	'''return the node set up to 2 levels for u '''
	nodeSet = set()
	nodeSet.add(u)
	for v in (set(G.predecessors(u)) | set(G.successors(u))):
		nodeSet.add(v)
		for j in (set(G.predecessors(v)) | set(G.successors(v))):
			nodeSet.add(j)
	return list(nodeSet)

if __name__=="__main__":
	nodeSeedSet = random.sample(G.nodes(), 1)
	nodeSampleSet = nodeSeedSet
	nodeSampleSet = set(nodeSampleSet)

	for u in nodeSeedSet:
		# add u's neighborhood to the set
		nodeSampleSet = nodeSampleSet | set(getNeighborhood(G, u))

	nodeSampleSet = list(nodeSampleSet)
	print len(nodeSampleSet), "nodes added."


