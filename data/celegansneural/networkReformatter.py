import networkx as nx

G = nx.read_gml("celegansneural.gml")

graphName = "celegansneural"
N = G.number_of_nodes()
mapping = dict(zip(range(0,N), range(1,N+1)))
G = nx.relabel_nodes(G, mapping)

nodelistFileName = "celegansneural-directed-nodelist.txt"
edgeListFileName = "celegansneural-directed-edgelist.txt"

nx.write_edgelist(G, edgeListFileName, data=False)

fw = open(nodelistFileName, "w")
print >>fw, "node"
for v in G.nodes():
	print >>fw, "%d" % (v)
fw.close()

