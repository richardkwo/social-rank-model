import networkx as nx

G = nx.read_gml("./data/football/football.gml")

graphName = "football"
N = G.number_of_nodes()
mapping = dict(zip(range(0,N), range(1,N+1)))
G = nx.relabel_nodes(G, mapping)

nodelistFileName = "./data/football/football-nodelist.txt"
edgeListFileName = "./data/football/football-edgelist.txt"

nx.write_edgelist(G, edgeListFileName, data=False)

fw = open(nodelistFileName, "w")
print >>fw, "node\tlabel\tleague"
for v in G.nodes():
	print >>fw, "%d\t%s\t%d" % (v, G.node[v]["label"], G.node[v]["value"])
fw.close()

