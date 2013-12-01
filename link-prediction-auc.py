import numpy as np
import networkx as nx
import random 

workingDir = "data/celegansneural/edge-removal/"
batchProfileFileName = workingDir + "batch-profile.txt"
networkFileName = "data/celegansneural/celegansneural-directed-edgelist.txt"
aucResultFileName = workingDir + "auc-result.txt"

def sampleWithReplacement(population, k):
    "Chooses k random elements (with replacement) from a population"
    n = len(population)
    _random, _int = random.random, int  # speed hack 
    result = [None] * k
    for i in xrange(k):
        j = _int(_random() * n)
        result[i] = population[j]
    return result

def uvLinkProb(Ru, Rv, Hu):
	"the prob of link u -> v"
	return 1.0/(1+np.exp(-(Rv - Ru - Hu)))

def aucForBatch(thisBatch, G):
	print "\nWorking on batch", thisBatch, "\n"
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
		cnt += 1
		if cnt==1: continue
		l = l.rstrip()
		l = l.split(" ")
		i = int(l[0])
		R[i] = float(l[1])
		H[i] = float(l[2])
	fr3.close()
	print "-- model estimates for %d nodes loaded from" % (len(R)), thisBatchEstimationFileName


	# edge removal
	Gg = G.copy()
	N  = G.number_of_nodes()
	for e in removedEdges:
		try:
			Gg.remove_edge(e[0], e[1])
		except:
			# might be repitition in edge list
			pass
	print "Edge removed..."


	# sample a portion of removed edges
	removedEdgesSampled = random.sample(removedEdges, min(len(removedEdges), 1000))
	# removedEdgesSampled = sampleWithReplacement(removedEdges, 1000)

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

	aucNegativeCountCommonNeighbor = 0
	aucNegativeCountCommonSuc = 0
	aucNegativeCountCommonPre = 0
	aucNegativeCountJaccard = 0
	aucNegativeCountProdOutDeg = 0
	aucNegativeCountProdInDeg = 0
	aucNegativeCountProdDeg = 0
	aucNegativeCountShortestPath = 0
	aucNegativeCountModel = 0

	print "Sampling..."
	for ePos in removedEdgesSampled:
		i = ePos[0]
		j = ePos[1]
		# sample an non-existing edge u -> v
		while (True):
			u = random.sample(range(1, N+1), 1)[0]
			v = random.sample(range(1, N+1), 1)[0]
			if v==u: continue
			if (v not in G[u]): break
		# i -> j is the real link (real positive)
		# u -> v is non-existent (real negative)
		## heuristics are computed on Gg
		## model
		if (uvLinkProb(R[i], R[j], H[i]) > uvLinkProb(R[u], R[v], H[u])): 
			aucCountModel += 1
		elif (uvLinkProb(R[i], R[j], H[i]) < uvLinkProb(R[u], R[v], H[u])): 
			aucNegativeCountModel += 1
		else:
			aucCountModel += 1
			aucNegativeCountModel += 1

		## degree-based
		indegree_i = Gg.in_degree(i)
		indegree_j = Gg.in_degree(j)
		outdegree_i = Gg.out_degree(i)
		outdegree_j = Gg.out_degree(j)
		indegree_u = Gg.in_degree(u)
		indegree_v = Gg.in_degree(v)
		outdegree_u = Gg.out_degree(u)
		outdegree_v = Gg.out_degree(v)

		if (indegree_i * indegree_j > indegree_u *  indegree_v): 
			aucCountProdInDeg += 1
		elif (indegree_i * indegree_j < indegree_u *  indegree_v):
			aucNegativeCountProdInDeg += 1
		else:
			aucCountProdInDeg += 1
			aucNegativeCountProdInDeg += 1


		if (outdegree_i * outdegree_j > outdegree_u *  outdegree_v): 
			aucCountProdOutDeg += 1
		elif (outdegree_i * outdegree_j < outdegree_u *  outdegree_v): 
			aucNegativeCountProdOutDeg += 1
		else:
			aucCountProdOutDeg += 1
			aucNegativeCountProdOutDeg += 1


		if ((indegree_i + outdegree_i) * (indegree_j + outdegree_j) > (indegree_u + outdegree_u) * (indegree_v + outdegree_v)): 
			aucCountProdDeg+=1
		elif ((indegree_i + outdegree_i) * (indegree_j + outdegree_j) < (indegree_u + outdegree_u) * (indegree_v + outdegree_v)): 
			aucNegativeCountProdDeg += 1
		else:
			aucCountProdDeg+=1
			aucNegativeCountProdDeg += 1


		## neighbor-based
		preSet_i = set(Gg.predecessors(i))
		sucSet_i = set(Gg.successors(i))
		preSet_j = set(Gg.predecessors(j))
		sucSet_j = set(Gg.successors(j))
		preSet_u = set(Gg.predecessors(u))
		sucSet_u = set(Gg.successors(u))
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

		if (len(preSet_i & preSet_j) > len(preSet_u & preSet_v)): 
			aucCountCommonPre += 1
		elif (len(preSet_i & preSet_j) < len(preSet_u & preSet_v)):
			aucNegativeCountCommonPre += 1
		else:
			aucCountCommonPre += 1
			aucNegativeCountCommonPre += 1

		if (len(sucSet_i & sucSet_j) > len(sucSet_u & sucSet_v)): 
			aucCountCommonSuc += 1
		elif (len(sucSet_i & sucSet_j) < len(sucSet_u & sucSet_v)):
			aucNegativeCountCommonSuc += 1
		else:
			aucCountCommonSuc += 1
			aucNegativeCountCommonSuc += 1


		if (len((preSet_i | sucSet_i) & (preSet_j | sucSet_j)) > len((preSet_u | sucSet_u) & (preSet_v | sucSet_v))): 
			aucCountCommonNeighbor += 1
		elif (len((preSet_i | sucSet_i) & (preSet_j | sucSet_j)) < len((preSet_u | sucSet_u) & (preSet_v | sucSet_v))):
			aucNegativeCountCommonNeighbor += 1
		else:
			aucCountCommonNeighbor += 1
			aucNegativeCountCommonNeighbor += 1


		if (jaccard_ij > jaccard_uv): 
			aucCountJaccard += 1
		elif (jaccard_ij < jaccard_uv): 
			aucNegativeCountJaccard += 1
		else:
			aucCountJaccard += 1
			aucNegativeCountJaccard += 1

		## shortest path 
		try:
			shortestPath_ij = len(nx.shortest_path(Gg, source=i, target=j)) - 1			
		except:
			shortestPath_ij = 1000000
		try: 
			shortestPath_uv = len(nx.shortest_path(Gg, source=u, target=v)) - 1
		except:
			shortestPath_uv = 1000000
		if (1.0/shortestPath_ij > 1.0/shortestPath_uv): 
			aucCountShortestPath += 1
		elif (1.0/shortestPath_ij < 1.0/shortestPath_uv): 
			aucNegativeCountShortestPath += 1
		else:
			aucCountShortestPath += 1
			aucNegativeCountShortestPath += 1

	# get aucs from samples
	auc = {}
	auc["CommonNeighbor"] = 1.0 * aucCountCommonNeighbor / (aucCountCommonNeighbor + aucNegativeCountCommonNeighbor)
	auc["CommonSuc"] = 1.0 * aucCountCommonSuc / (aucCountCommonSuc + aucNegativeCountCommonSuc)
	auc["CommonPre"] = 1.0 * aucCountCommonPre / (aucCountCommonPre + aucNegativeCountCommonPre)
	auc["Jaccard"] = 1.0 * aucCountJaccard / (aucCountJaccard + aucNegativeCountJaccard)
	auc["ProdOutDeg"] = 1.0 * aucCountProdOutDeg / (aucCountProdOutDeg + aucNegativeCountProdOutDeg)
	auc["ProdInDeg"] = 1.0 * aucCountProdInDeg / (aucCountProdInDeg + aucNegativeCountProdInDeg)
	auc["ProdDeg"] = 1.0 * aucCountProdDeg / (aucCountProdDeg + aucNegativeCountProdDeg)
	auc["ShortestPath"] = 1.0 * aucCountShortestPath / (aucCountShortestPath + aucNegativeCountShortestPath)
	auc["Model"] = 1.0 * aucCountModel / (aucCountModel + aucNegativeCountModel)

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
	print "Batch loaded from", batchProfileFileName
	for t in range(0, len(batches)):
		print batches[t], numberRemovedEdges[t], fractionRemovecEdges[t]

	features = ["CommonNeighbor", "CommonSuc", "CommonPre", "Jaccard", "ProdOutDeg", "ProdInDeg", 
	"ProdDeg", "ShortestPath", "Model"]
	# renew file and write header
	fw = open(aucResultFileName, "w")
	print >>fw, '\"%s\" ' * (3+len(features)) % tuple(["batch", "number.removed.egdes", "fraction.removed.edges"] + features)
	fw.close()
	# compute AUC for each batch
	for t in range(0, len(batches)):
		batch = batches[t]
		auc = aucForBatch(batch, G)
		print ""
		for k in auc.keys():
			print "<<%s>> %-9s:%-.4f" % (batch, k, auc[k])
		# write to file
		fw = open(aucResultFileName, 'a')
		formatterStr = "%s %d %.3f " + "%.5f " * len(features)
		print >>fw, formatterStr % tuple([batch, numberRemovedEdges[t], fractionRemovecEdges[t]] + 
			[auc[x] for x in features])
		fw.close()

	print "\nAUC written to", aucResultFileName



