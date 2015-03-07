from graph import *


def powerSet(xs):
    if len(xs) == 0:
        return [[]]

    else:
        # xs = head:tail
        head = xs[0]
        tail = xs[1:]

        prev = powerSet(tail)
        incl = map(lambda sub: sub + [head], prev)
        return prev + incl


def powerGraph(graph):
    nodes = []

    for n in graph.nodes:
        nodes.append(n)

    pSet = powerSet(nodes)
    return pSet


def isClique(graph, subGraph):
    for n in subGraph:
        for m in subGraph:
            if not m == n:
                if n not in graph.childrenOf(m):
                    return False

    return True


def maxClique(graph):
    maximum = None
    maxLen = 0
    subGraphs = powerGraph(graph)

    for sub in subGraphs:
        if isClique(graph, sub):
            if len(sub) > maxLen:
                maximum = sub
                maxLen = len(sub)

    return maximum


def testGraph():
    nodes = []
    for name in range(5):
        nodes.append(Node(str(name)))
    g = Graph()
    for n in nodes:
        g.addNode(n)
    g.addEdge(Edge(nodes[0],nodes[1]))
    g.addEdge(Edge(nodes[1],nodes[2]))
    g.addEdge(Edge(nodes[2],nodes[0]))
    g.addEdge(Edge(nodes[2],nodes[4]))
    g.addEdge(Edge(nodes[4],nodes[3]))
    return g


trialGraph = testGraph()
myClique = maxClique(trialGraph)

print myClique
