# 6.00.2x Problem Set 5
# Graph optimization
# Finding shortest paths through MIT buildings
#

import string
import copy
# This imports everything from `graph.py` as if it was defined in this file!
from graph import * 

#
# Problem 2: Building up the Campus Map
#
# Before you write any code, write a couple of sentences here 
# describing how you will model this problem as a graph. 

# This is a helpful exercise to help you organize your
# thoughts before you tackle a big design problem!
#

def load_map(mapFilename):
    nodes = set([])
    edges = []

    ins = open(mapFilename, "r")
    for line in ins:
        # start, dest, total, outdoor
        s, d, t, o = tuple(map(int, line.strip().split()))
        start = Node(s)
        dest = Node(d)
        nodes.add(start)
        nodes.add(dest)
        edges.append(WeightedEdge(start, dest, t, o))

    g = WeightedDigraph()

    for n in nodes:
        g.addNode(n)

    for e in edges:
        g.addEdge(e)

    return g


#
# Problem 3: Finding the Shortest Path using Brute Force Search
#
# State the optimization problem as a function to minimize
# and what the constraints are
#

class DistancePath(object):
    def __init__(self, path, total, out):
        self.path = path
        self.totalDistance = total
        self.outdoorDistance = out

    def __str__(self):
        res = '' + str(self.path) + '\n'
        res = '{0}total: {1}, outdoor: {2}'. format(res,
                                                    self.totalDistance,
                                                    self.outdoorDistance)

        return res


# assumes graph is a directed graph
def allDFSPaths(graph, start, end, distPath):
    distPath.path += [start]
    distPaths = []

    if start == end:
        distPaths.append(distPath)
        return distPaths

    for edge in graph.childrenOf(start):
        node = edge[0]
        total, outdoor = edge[1]
        if node not in distPath.path:
            newPath = copy.deepcopy(distPath)
            newPath.totalDistance += total
            newPath.outdoorDistance += outdoor

            subDistPaths = allDFSPaths(graph, node, end, newPath)
            if subDistPaths:
                distPaths += subDistPaths

    return distPaths


def bruteForceSearch(digraph, start, end, maxTotalDist, maxDistOutdoors):
    init = DistancePath([], 0, 0)
    paths = allDFSPaths(digraph, Node(start), Node(end), init)

    valid = filter(lambda dp:
                   dp.totalDistance <= maxTotalDist and
                   dp.outdoorDistance <= maxDistOutdoors, paths)

    if not valid:
        raise ValueError('no valid paths')

    shortest = min(valid, key=lambda dp: dp.totalDistance)

    return map(lambda x: str(x), shortest.path)

#
# Problem 4: Finding the Shorest Path using Optimized Search Method
#


def directedDFS(digraph, start, end, maxTotalDist, maxDistOutdoors):

    def shortestDFS(graph, start, end, distPath, shortest=None):
        distPath.path += [start]

        if start == end:
            return distPath

        for edge in graph.childrenOf(start):
            node = edge[0]
            total, outdoor = edge[1]
            if node not in distPath.path:

                if distPath.totalDistance + total <= maxTotalDist and \
                   distPath.outdoorDistance + outdoor <= maxDistOutdoors and \
                   (shortest is None or distPath.totalDistance + total < shortest.totalDistance):
                    newPath = copy.deepcopy(distPath)
                    newPath.totalDistance += total
                    newPath.outdoorDistance += outdoor

                    found = shortestDFS(graph, node, end, newPath, shortest)

                    if found is not None:
                        shortest = found

        return shortest

    init = DistancePath([], 0, 0)
    shortest = shortestDFS(digraph, Node(start), Node(end), init)

    if shortest is None:
        raise ValueError('no valid path')
    else:
        return map(lambda x: str(x), shortest.path)

g = load_map('small_map.txt')
print directedDFS(g, '1', '4', 100, 50)


# Uncomment below when ready to test
#### NOTE! These tests may take a few minutes to run!! ####
# if __name__ == '__main__':
#     Test cases
#     mitMap = load_map("mit_map.txt")
#     print isinstance(mitMap, Digraph)
#     print isinstance(mitMap, WeightedDigraph)
#     print 'nodes', mitMap.nodes
#     print 'edges', mitMap.edges


#     LARGE_DIST = 1000000

#     Test case 1
#     print "---------------"
#     print "Test case 1:"
#     print "Find the shortest-path from Building 32 to 56"
#     expectedPath1 = ['32', '56']
#     brutePath1 = bruteForceSearch(mitMap, '32', '56', LARGE_DIST, LARGE_DIST)
#     dfsPath1 = directedDFS(mitMap, '32', '56', LARGE_DIST, LARGE_DIST)
#     print "Expected: ", expectedPath1
#     print "Brute-force: ", brutePath1
#     print "DFS: ", dfsPath1
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath1 == brutePath1, expectedPath1 == dfsPath1)

#     Test case 2
#     print "---------------"
#     print "Test case 2:"
#     print "Find the shortest-path from Building 32 to 56 without going outdoors"
#     expectedPath2 = ['32', '36', '26', '16', '56']
#     brutePath2 = bruteForceSearch(mitMap, '32', '56', LARGE_DIST, 0)
#     dfsPath2 = directedDFS(mitMap, '32', '56', LARGE_DIST, 0)
#     print "Expected: ", expectedPath2
#     print "Brute-force: ", brutePath2
#     print "DFS: ", dfsPath2
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath2 == brutePath2, expectedPath2 == dfsPath2)

#     Test case 3
#     print "---------------"
#     print "Test case 3:"
#     print "Find the shortest-path from Building 2 to 9"
#     expectedPath3 = ['2', '3', '7', '9']
#     brutePath3 = bruteForceSearch(mitMap, '2', '9', LARGE_DIST, LARGE_DIST)
#     dfsPath3 = directedDFS(mitMap, '2', '9', LARGE_DIST, LARGE_DIST)
#     print "Expected: ", expectedPath3
#     print "Brute-force: ", brutePath3
#     print "DFS: ", dfsPath3
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath3 == brutePath3, expectedPath3 == dfsPath3)

#     Test case 4
#     print "---------------"
#     print "Test case 4:"
#     print "Find the shortest-path from Building 2 to 9 without going outdoors"
#     expectedPath4 = ['2', '4', '10', '13', '9']
#     brutePath4 = bruteForceSearch(mitMap, '2', '9', LARGE_DIST, 0)
#     dfsPath4 = directedDFS(mitMap, '2', '9', LARGE_DIST, 0)
#     print "Expected: ", expectedPath4
#     print "Brute-force: ", brutePath4
#     print "DFS: ", dfsPath4
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath4 == brutePath4, expectedPath4 == dfsPath4)

#     Test case 5
#     print "---------------"
#     print "Test case 5:"
#     print "Find the shortest-path from Building 1 to 32"
#     expectedPath5 = ['1', '4', '12', '32']
#     brutePath5 = bruteForceSearch(mitMap, '1', '32', LARGE_DIST, LARGE_DIST)
#     dfsPath5 = directedDFS(mitMap, '1', '32', LARGE_DIST, LARGE_DIST)
#     print "Expected: ", expectedPath5
#     print "Brute-force: ", brutePath5
#     print "DFS: ", dfsPath5
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath5 == brutePath5, expectedPath5 == dfsPath5)

#     Test case 6
#     print "---------------"
#     print "Test case 6:"
#     print "Find the shortest-path from Building 1 to 32 without going outdoors"
#     expectedPath6 = ['1', '3', '10', '4', '12', '24', '34', '36', '32']
#     brutePath6 = bruteForceSearch(mitMap, '1', '32', LARGE_DIST, 0)
#     dfsPath6 = directedDFS(mitMap, '1', '32', LARGE_DIST, 0)
#     print "Expected: ", expectedPath6
#     print "Brute-force: ", brutePath6
#     print "DFS: ", dfsPath6
#     print "Correct? BFS: {0}; DFS: {1}".format(expectedPath6 == brutePath6, expectedPath6 == dfsPath6)

#     Test case 7
#     print "---------------"
#     print "Test case 7:"
#     print "Find the shortest-path from Building 8 to 50 without going outdoors"
#     bruteRaisedErr = 'No'
#     dfsRaisedErr = 'No'
#     try:
#         bruteForceSearch(mitMap, '8', '50', LARGE_DIST, 0)
#     except ValueError:
#         bruteRaisedErr = 'Yes'
    
#     try:
#         directedDFS(mitMap, '8', '50', LARGE_DIST, 0)
#     except ValueError:
#         dfsRaisedErr = 'Yes'
    
#     print "Expected: No such path! Should throw a value error."
#     print "Did brute force search raise an error?", bruteRaisedErr
#     print "Did DFS search raise an error?", dfsRaisedErr

#     Test case 8
#     print "---------------"
#     print "Test case 8:"
#     print "Find the shortest-path from Building 10 to 32 without walking"
#     print "more than 100 meters in total"
#     bruteRaisedErr = 'No'
#     dfsRaisedErr = 'No'
#     try:
#         bruteForceSearch(mitMap, '10', '32', 100, LARGE_DIST)
#     except ValueError:
#         bruteRaisedErr = 'Yes'
    
#     try:
#         directedDFS(mitMap, '10', '32', 100, LARGE_DIST)
#     except ValueError:
#         dfsRaisedErr = 'Yes'
    
#     print "Expected: No such path! Should throw a value error."
#     print "Did brute force search raise an error?", bruteRaisedErr
#     print "Did DFS search raise an error?", dfsRaisedErr
