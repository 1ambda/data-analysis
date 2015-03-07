class Node(object):
    def __init__(self, name):
        self.name = str(name)

    def getName(self): return self.name 
    def __str__(self):
        return self.name


class Edge(object):
    def __init__(self, src, dest):
        self.src = src
        self.dest = dest

    def getSrc(self):
        return self.src

    def getDest(self):
        return self.dest

    def __str__(self):
        return str(self.src) + ' -> ' + str(self.dest)


class WeightedEdge(Edge):
    def __init__(self, src, dest, weight=1.0):
        self.src = src
        self.dest = dest
        self.weight = weight

    def getWeight(self):
        return self.weight

    def __str__(self):
        return str(self.src) + ' -> ('\
            + str(self.weight) + ')'\
            + str(self.dest)


class Digraph(object):
    def __init__(self):
        self.nodes = set([])
        self.edges = {}

    def addNode(self, node):
        if node in self.nodes:
            raise ValueError('duplicated node')
        else:
            self.nodes.add(node)
            self.edges[node] = []

    def addEdge(self, edge):
        src = edge.getSrc()
        dest = edge.getDest()

        if not(src in self.nodes and dest in self.nodes):
            raise ValueError('unknown node')

        self.edges[src].append(dest)

    def childrenOf(self, node):
        return self.edges[node]

    def hasNode(self, node):
        return node in self.nodes

    def __str__(self):
        res = ''

        for src in self.edges:
            for dest in self.edges[src]:
                res = res + str(src) + ' -> ' + str(dest) + '\n'

        return res[:-1]


# undirected
class Graph(Digraph):
    def addEdge(self, edge):
        Digraph.addEdge(self, edge)
        rev = Edge(edge.getDest(), edge.getSrc())
        Digraph.addEdge(self, rev)


def makeEdge(nodes, src, dest):
    return Edge(nodes[src], nodes[dest])


def testGraph():
    nodes = []

    # index will be the name of each node
    for idx in range(6):
        nodes.append(Node(str(idx)))

    g = Digraph()

    for n in nodes:
        g.addNode(n)

    srcs = [0, 1, 2, 2, 3, 3, 0, 1, 3, 4]
    dests = [1, 2, 3, 4, 4, 5, 2, 0, 1, 0]

    for (s, d) in zip(srcs, dests):
        g.addEdge(makeEdge(nodes, s, d))

    return g, nodes


# assumes graph is a directed graph
def DFS(graph, start, end, path=[]):
    path = path + [start]

    if start == end:
        return path

    for node in graph.childrenOf(start):
        if node not in path:
            newPath = DFS(graph, node, end, path)

            if newPath is not None:
                return newPath

    return None


# assumes graph is a directed graph
def shortestDFS(graph, start, end, path=[], shortest=None):
    path = path + [start]

    if start == end:
        return path

    for node in graph.childrenOf(start):
        if node not in path:
            if shortest is None or len(path) < len(shortest):
                newPath = shortestDFS(graph, node, end, path, shortest)
                if newPath is not None:
                    shortest = newPath

    return shortest


def BFS(graph, start, end, q=[]):
    init = [start]
    q.append(init)

    while len(q) != 0:
        # get a path from q
        current = q.pop(0)
        lastNode = current[len(current) - 1]
        if lastNode == end:
            return current

        for nextNode in graph.childrenOf(lastNode):
            if nextNode not in current:
                path = current + [nextNode]
                q.append(path)

    return None


def visit():
    g, nodes = testGraph()
    path = BFS(g, nodes[0], nodes[5], [])

    for p in path:
        print p

visit()
