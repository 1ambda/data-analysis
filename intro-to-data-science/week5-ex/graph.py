# 6.00.2x Problem Set 5
# Graph optimization
#
# A set of data structures to represent graphs
#


class Node(object):
    def __init__(self, name):
        self.name = str(name)

    def getName(self):
        return self.name

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name

    def __eq__(self, other):
        return self.name == other.name

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        # Override the default hash method
        # Think: Why would we want to do this?
        return self.name.__hash__()


class Edge(object):
    def __init__(self, src, dest):
        self.src = src
        self.dest = dest

    def getSource(self):
        return self.src

    def getDestination(self):
        return self.dest

    def __str__(self):
        return '{0}->{1}'.format(self.src, self.dest)



class Digraph(object):
    """
    A directed graph
    """
    def __init__(self):
        self.nodes = set([])
        self.edges = {}

    def addNode(self, node):
        if node in self.nodes:
            raise ValueError('Duplicate node')
        else:
            self.nodes.add(node)
            self.edges[node] = []

    def addEdge(self, edge):
        src = edge.getSource()
        dest = edge.getDestination()
        if not(src in self.nodes and dest in self.nodes):
            raise ValueError('Node not in graph')
        self.edges[src].append(dest)

    def childrenOf(self, node):
        return self.edges[node]

    def hasNode(self, node):
        return node in self.nodes

    def __str__(self):
        res = ''
        for k in self.edges:
            for d in self.edges[str(k)]:
                res = '{0}{1}->{2}\n'.format(res, k, d)
        return res[:-1]


class WeightedEdge(Edge):
    def __init__(self, src, dest, total, out):
        assert out <= total

        self.src = src
        self.dest = dest
        self.totalDist = int(total)
        self.outdoorDist = int(out)

    def getTotalDistance(self):
        return self.totalDist

    def getOutdoorDistance(self):
        return self.outdoorDist

    def __str__(self):
        return '{0}->{1} ({2}, {3})'.format(self.src,
                                            self.dest,
                                            self.totalDist,
                                            self.outdoorDist)


class WeightedDigraph(Digraph):
    def __init__(self):
        self.nodes = set([])
        self.edges = {}

    def addEdge(self, edge):
        src = edge.getSource()
        dest = edge.getDestination()
        total = edge.getTotalDistance()
        outdoor = edge.getOutdoorDistance()

        if not (src in self.nodes and dest in self.nodes):
            raise ValueError('Node not exist')

        self.edges[src].append([dest, (total, outdoor)])

    def childrenOf(self, node):
        adjs = []
        for dest in self.edges[node]:
            adjs.append(dest)

        return adjs

    def __str__(self):
        res = ''

        for src in self.edges:
            for edge in self.edges[src]:
                dest = edge[0]
                total, outdoor = edge[1]
                res = '{0}{1}->{2} ({3}, {4})\n'.format(res,
                                                        src,
                                                        dest,
                                                        float(total),
                                                        float(outdoor))

        return res[:-1]

