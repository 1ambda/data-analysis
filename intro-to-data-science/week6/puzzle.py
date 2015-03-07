

class puzzle(object):
    def __init__(self, order):
        self.label = order

        for i in range(9):
            if order[i] == '0':
                self.spot = i
                return None

    def transition(self, to):
        currentLabel = self.label
        blank = self.spot
        current = str(currentLabel[to]) # current slot which will be blank
        nextLabel = ''

        for i in range(9):
            if i == to:
                nextLabel += '0'
            elif i == blank:
                nextLabel += current
            else:
                nextLabel += str(currentLabel[i])

        return puzzle(nextLabel)

    def __str__(self):
        return "{0} {1} {2}\n{3} {4} {5}\n{6} {7} {8}\n".format(self.label[0],
                                                                self.label[1],
                                                                self.label[2],
                                                                self.label[3],
                                                                self.label[4],
                                                                self.label[5],
                                                                self.label[6],
                                                                self.label[7],
                                                                self.label[8])

shifts = {}
shifts[0] = [1, 3]
shifts[1] = [0, 2, 4]
shifts[2] = [1, 5]
shifts[3] = [0, 4, 6]
shifts[4] = [1, 3, 5, 7]
shifts[5] = [2, 4, 8]
shifts[6] = [3, 7]
shifts[7] = [4, 6, 8]
shifts[8] = [5, 7]


def notInPath(state, path):
    for s in path:
        if s.label == state.label:
            return False

    return True


def BFS(start, end, q=[]):
    initPath = [start]
    q.append(initPath)

    while len(q) != 0:
        currentPath = q.pop(0)
        lastState = currentPath[len(currentPath) - 1]

        if lastState.label == end.label:
            return currentPath

        for s in shifts[lastState.spot]:
            nextState = lastState.transition(s)

            if notInPath(nextState, currentPath):
                nextPath = currentPath + [nextState]
                q.append(nextPath)

    return None


def DFS(start, end, stack=[]):
    initPath = [start]
    stack.insert(0, initPath)

    while len(stack) != 0:
        currentPath = stack.pop(0)
        lastState = currentPath[len(currentPath) - 1]

        if lastState.label == end.label:
            return currentPath

        for s in shifts[lastState.spot]:
            nextState = lastState.transition(s)

            if notInPath(nextState, currentPath):
                nextPath = currentPath + [nextState]
                stack.insert(0, nextPath)

    return None


def test():
    goal = puzzle('012345678')
    test1 = puzzle('125638047')
    answer1 = DFS(test1, goal)
    answer2 = BFS(test1, goal)

    print len(answer1), len(answer2)

test()
