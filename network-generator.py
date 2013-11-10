import numpy as np
import networkx as nx
import matplotlib.pyplot as plt

N = 50
print "Hello"

# nodes
V = range(1, N+1)

def Phi(beta, R1, R2):
	return np.exp( -beta * (R1 - R2)**2 )

def getDegreeDistribution(G):
	degreeCount = {}
	degreeFreq = {}
	for v in G.nodes():
		k = G.degree(v)
		try:
			degreeCount[k] = degreeCount[k] + 1
		except:
			degreeCount[k] = 1
	for k in degreeCount.keys():
		degreeFreq[k] = degreeCount[k] * 1.0 / sum(degreeCount.values())
	plt.figure()
	kVec = sorted(degreeFreq.keys())
	freqVec = [degreeFreq[k] for k in kVec]
	plt.plot(kVec, freqVec)
	plt.yscale("log")
	plt.xscale("log")
	return degreeFreq

def saveNetwork(G, R, graphName="g1"):
	edgeListFileName = graphName + "-edgelist.txt"
	nodeListFileName = graphName + "-nodelist.txt"
	# relabel to node support, so that nodes are labeled 1...N
	nodeRemap = {}
	i = 0
	fw2 = open(nodeListFileName, "w")
	for v in G.nodes():
		i = i + 1
		nodeRemap[v] = i
		print >>fw2, "%d\t%.6f" % (i, R[v])
	print "nodes written to", nodeListFileName
	fw2.close()

	fw = open(edgeListFileName, "w")
	for e in G.edges():
		v1 = nodeRemap[e[0]]
		v2 = nodeRemap[e[1]]
		print >>fw, "%d\t%d" % (v1, v2)
	fw.close()
	
	print "edges written to", edgeListFileName

# latent ranks
R = {}
for v in V:
	R[v] = np.random.pareto(0.9)



# network
G = nx.Graph()
for i in range(1, N+1):
	for j in range(i+1, N+1):
		if np.random.binomial(1, Phi(15.0, R[i], R[j]))==1:
			G.add_edge(i,j)

print "N=", nx.number_of_nodes(G)
print "M=", nx.number_of_edges(G)
print "Linking prob = ", G.number_of_edges() * 1.0 / (N * (N-1)/2)
print "Transitivity = ", nx.transitivity(G)

plt.figure()
nodeColors = [R[v] for v in G.nodes()]
nodeLabels = {}

pos = nx.spring_layout(G)

for v in G.nodes():
	nodeLabels[v] = "%.2f" % (R[v])
posForLabel = {}
for v in G.nodes():
	posForLabel[v] = np.array([pos[v][0]-0.05, pos[v][1]])

nx.draw_networkx_nodes(G, pos=pos, node_color=nodeColors, alpha=1.0, node_size=80, vmin=0, vmax=1)
nx.draw_networkx_edges(G, pos=pos, alpha=0.8)
nx.draw_networkx_labels(G, pos=posForLabel, labels=nodeLabels, alpha=0.8)
plt.show()



