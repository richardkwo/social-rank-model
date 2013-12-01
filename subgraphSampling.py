import networkx as nx

def getNeighborhood(G, u):
	'''return the node set up to 2 levels for u '''
	nodeSet = set[]
	nodeSet.add(u)
	for v in G[u]:
		nodeSet.add(v)
		for j in G[v]:
			nodeSet.add(j)
	return list(nodeSet)




