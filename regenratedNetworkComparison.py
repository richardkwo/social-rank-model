import networkx as nx
import numpy as np

realNetworkFileName = "data/" + "celegansneural/celegansneural-directed-edgelist.txt"
regeneratedFileName = "RegeneratedData/" + "Celegans-neural-edgelist-regenerated.txt"

def getInDegreeSeq(G):
	indegreeSeq = sorted([G.in_degree(u) for u in G.nodes()], reverse=True)
	return (indegreeSeq)

def getOutDegreeSeq(G):
	outdegreeSeq = sorted([G.out_degree(u) for u in G.nodes()], reverse=True)
	return (outdegreeSeq)

if __name__=="__main__":
	Gorig = nx.read_edgelist(realNetworkFileName, create_using=nx.DiGraph(), nodetype=int)
	Gregen =  nx.read_edgelist(regeneratedFileName, create_using=nx.DiGraph(), nodetype=int)
	print "Real network loaded with N =", Gorig.number_of_nodes(), "M=", Gorig.number_of_edges()
	print "Regenerated Network loaded with N =", Gregen.number_of_nodes(), "M =", Gregen.number_of_edges()
	print ""

	indegreeSequenceOrig = getInDegreeSeq(Gorig)
	indegreeSequenceRegen = getInDegreeSeq(Gregen)
	outdegreeSequenceOrig = getOutDegreeSeq(Gorig)
	outdegreeSequenceRegen = getOutDegreeSeq(Gregen)

	avInDegree = [np.mean(indegreeSequenceOrig), np.mean(indegreeSequenceRegen)]

	trans = [nx.transitivity(Gorig), nx.transitivity(Gregen)]
	avShortedPathLength = [nx.average_shortest_path_length(Gorig), nx.average_shortest_path_length(Gregen)]
	degreePearson = [nx.degree_pearson_correlation_coefficient(Gorig), nx.degree_pearson_correlation_coefficient(Gregen)]

	print "average in-degree", avInDegree
	print "transitivity", trans
	print "average shortest path", avShortedPathLength
	print "degree pearson", degreePearson


