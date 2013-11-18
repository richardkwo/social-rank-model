import networkx as nx

G = nx.read_gml("polblogs.gml")

graphName = "polblogs"
N = G.number_of_nodes()


nodelistFileName = "polblogs-nodelist.txt"
edgeListFileName = "polblogs-edgelist.txt"

nx.write_edgelist(G, edgeListFileName, data=False)

fw = open(nodelistFileName, "w")
print >>fw, "node\tvalue"
for v in G.nodes():
	print >>fw, "%d\t%d" % (v, G.node[v]["value"])
fw.close()

