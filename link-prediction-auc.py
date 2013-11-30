import numpy as np
import networkx as nx
import random as random

workingDir = "data/celegansneural/edge-removal/"
batchProfileFileName = workingDir + "batch-profile.txt"
networkFileName = "data/celegansneural/celegansneural-directed-edgelist.txt"

def uvLinkProb(Ru, Rv, Hu):
	return 1.0/(1+exp(-(Rv - Ru - Hu)))

def aucForBatch(thisBatch, G):
	thisBatchRemovedEdgesFileName = workingDir + "removed-edges-" + thisBatch + ".txt"
	thisBatchEstimationFileName = workingDir + "estimate-" + thisBatch + ".txt"

	removedEdges = []
	
	# read removed edges
	fr2 = open(thisBatchRemovedEdgesFileName, 'r')
	edgeRemovedTotal = 0
	for l in fr2:
		l = l.rstrip()
		if l=="": continue
		l = l.split(" ")
		removedEdges.append((int(l[0]), int(l[1])))
		edgeRemovedTotal += 1
	fr2.close()
	print "-- %d removed edges loaded from" % (edgeRemovedTotal), thisBatchRemovedEdgesFileName

	# read estimates
	fr3 = open(thisBatchEstimationFileName, 'r')
	cnt = 0
	R = {}
	H = {}
	for l in fr3:
		if cnt==0: continue
		l = l.rstrip()
		l = l.split(" ")
		i = int(l[0])
		R[i] = float(l[1])
		H[i] = float(l[2])
	fr3.close()
	print "-- model estimates loaded from", thisBatchEstimationFileName


	# edge removal
	Gg = G.copy()
	N  = G.number_of_nodes()
	for e in removedEdges:
		Gg.remove_edge(e[0], e[1])


	# sample a portion of removed edges
	removedEdgesSampled = random.sample(removedEdges, min(len(removedEdges), 500))
	# test on each edge
	aucCountCommonNeighbor = 0
	aucCountCommonSuc = 0
	aucCountCommonPre = 0
	aucCountJaccard = 0
	aucCountProdOutDeg = 0
	aucCountProdInDeg = 0
	aucCountProdDeg = 0
	aucCountShortestPath = 0
	aucCountModel = 0

	for ePos in removedEdgesSampled:
		i = ePos[0]
		j = ePos[1]
		# sample an non-existing edge u -> v
		while (True):
			u = random.sample(range(1, N+1))
			v = random.sample(range(1, N+1))
			if (v not in G[u]): break
		# i -> j is the real link
		## model
		if uvLinkProb(R[i], R[j], H[i]) > uvLinkProb(R[u], R[v], H[u]): aucCountModel += 1
		## degree-based
		indegree_i = Gg.in_degree(i)
		indegree_j = Gg.in_degree(j)
		outdegree_i = Gg.out_degree(i)
		outdegree_j = Gg.out_degree(j)
		indegree_u = Gg.in_degree(u)
		indegree_v = Gg.in_degree(v)
		outdegree_u = Gg.out_degree(u)
		outdegree_v = Gg.out_degree(v)

		if (indegree_i * indegree_j > indegree_u *  indegree_v): aucCountProdInDeg += 1
		if (outdegree_i * outdegree_j > outdegree_u *  outdegree_v): aucCountProdOutDeg += 1
		if ((indegree_i + outdegree_i) * (indegree_j + outdegree_j) > (indegree_u + outdegree_u) * (indegree_v + outdegree_v)): aucCountProdDeg+=1
		## neighbor-based
		preSet_i = set(Gg.predecessors(i))
		sucSet_i = set(Gg.successors(i))
		preSet_j = set(Gg.predecessors(j))
		sucSet_j = set(Gg.successors(j))
		preSet_u = set(Gg.predecessors(u))
		sucSet_u = set(Gg.successors(u)))
		preSet_v = set(Gg.predecessors(v))
		sucSet_v = set(Gg.successors(v))

		if (len((preSet_i | sucSet_i) | (preSet_j | sucSet_j))==0): 
			jaccard_ij = 0
		else:
			jaccard_ij = 1.0 * len((preSet_i | sucSet_i) & (preSet_j | sucSet_j)) / len((preSet_i | sucSet_i) | (preSet_j | sucSet_j))

		if (len((preSet_u | sucSet_u) | (preSet_v | sucSet_v))==0): 
			jaccard_uv = 0
		else:
			jaccard_uv = 1.0 * len((preSet_u | sucSet_u) & (preSet_v | sucSet_v)) / len((preSet_u | sucSet_u) | (preSet_v | sucSet_v))

		if (len(preSet_i & preSet_j) > len(preSet_u & preSet_v)): aucCountCommonPre += 1
		if (len(sucSet_i & sucSet_j) > len(sucSet_u & sucSet_v)): aucCountCommonSuc += 1
		if (len((preSet_i | sucSet_i) & (preSet_j | sucSet_j)) > len((preSet_u | sucSet_v) & (preSet_u | sucSet_v))): aucCountCommonNeighbor += 1
		if (jaccard_ij > jaccard_uv): aucCountJaccard += 1
		## shortest path 
		shortestPath_ij = nx.shortest_path(Gg, source=i, target=j)
		shortestPath_uv = nx.shortest_path(Gg, source=u, target=v)
		if (1.0/shortestPath_ij > 1.0/shortestPath_uv): aucCountShortestPath += 1

	# get aucs from samples
	auc = {}
	auc["CommonNeighbor"] = 1.0 * aucCountCommonNeighbor / len(removedEdgesSampled)
	auc["CommonSuc"] = 1.0 * aucCountCommonSuc / len(removedEdgesSampled)
	auc["CommonPre"] = 1.0 * aucCountCommonPre / len(removedEdgesSampled)
	auc["Jaccard"] = 1.0 * aucCountJaccard / len(removedEdgesSampled)
	auc["ProdOutDeg"] = 1.0 * aucCountProdOutDeg / len(removedEdgesSampled)
	auc["ProdInDeg"] = 1.0 * aucCountProdInDeg / len(removedEdgesSampled)
	auc["ProdDeg"] = 1.0 * aucCountProdDeg / len(removedEdgesSampled)
	auc["ShortestPath"] = 1.0 * aucCountShortestPath / len(removedEdgesSampled)
	auc["Model"] = 1.0 * aucCountModel / len(removedEdgesSampled)

	return auc



if __name__=="__main__":
	G = nx.read_edgelist(networkFileName, create_using=nx.DiGraph(), nodetype=int)
	N = G.number_of_nodes()
	print "Original network loaded with N=", G.number_of_nodes(), "M=", G.number_of_edges()

	# read batch profile
	fr = open(batchProfileFileName, "r")
	batches = []
	numberRemovedEdges = []
	fractionRemovecEdges = []
	cnt = 0
	for l in fr:
		cnt += 1
		if cnt > 1:
			l = l.rstrip()
			l = l.split(" ")
			batches.append(l[0].split('"')[1])
			numberRemovedEdges.append(int(l[1]))
			fractionRemovecEdges.append(float(l[2]))
	fr.close()

	# compute AUC for each batch
