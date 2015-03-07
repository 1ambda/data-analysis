class Item(object):
    def __init__(self, n, v, w):
        self.name = n
        self.value = v
        self.weight = w

    def getName(self):
        return self.name

    def getValue(self):
        return self.value

    def getWeight(self):
        return self.weight

    def __str__(self):
        result = '<' + self.name + ', ' + str(self.value)\
                 + ", " + str(self.weight) + '>'

        return result


def buildItems():
    names = ['clock', 'painting', 'radio',
             'vase', 'book', 'computer']

    vals = [175, 90, 20, 50, 10, 200]
    weights = [10, 9, 4, 2, 1, 20]

    Items = []

    for i in range(len(vals)):
        Items.append(Item(names[i], vals[i], weights[i]))

    return Items


def greedy(Items, maxWeight, predicate):
    assert type(Items) == list and maxWeight >= 0

    orderedItems = sorted(Items, key=predicate, reverse=True)

    result = []
    totalVal = 0.0
    totalWeight = 0.0
    i = 0

    while totalWeight < maxWeight and i < len(Items):
        if (totalWeight + orderedItems[i].getWeight()) <= maxWeight:
            result.append(orderedItems[i])
            totalWeight += orderedItems[i].getWeight()
            totalVal += orderedItems[i].getValue()

        i += 1

    return (result, totalVal)


# predicate
def value(item):
    return item.getValue()


def weightInverse(item):
    return 1.0 / item.getWeight()


def density(item):
    return item.getValue() / item.getWeight()


# test
def testGreedy(Items, constraint, pred):
    items, val = greedy(Items, constraint, pred)
    print ('Total value of items taken = ' + str(val))
    for item in items:
        print ' ', item


def greedySolution():
    maxWeight = 20
    Items = buildItems()
    print ('Items to choose from')
    for item in Items:
        print ' ', item

    print 'by value'
    testGreedy(Items, maxWeight, value)
    print 'by 1 / weight'
    testGreedy(Items, maxWeight, weightInverse)
    print 'by density'
    testGreedy(Items, maxWeight, density)


# brute force
def int2bin(n, digit):
    assert type(n) == int and type(digit) == int
    assert n >= 0 and n < 2 ** digit

    # binary string
    binStr = ''

    while n > 0:
        binStr = str(n % 2) + binStr
        n = n // 2

    while digit - len(binStr) > 0:
        binStr = '0' + binStr

    return binStr


def buildPowerSet(Items):
    count = 2 ** len(Items)
    binStrs = []

    for i in range(count):
        binStrs.append(int2bin(i, len(Items)))

    powerSet = []
    for bs in binStrs:
        elem = []
        for i in range(len(bs)):
            if bs[i] == '1':
                elem.append(Items[i])
        powerSet.append(elem)

    return powerSet


def optimalItems(powerSet, constraint, getValue, getWeight):
    optimalSet = None
    optimalValue = 0.0

    for Items in powerSet:
        ItemsValue = 0.0
        ItemsWeight = 0.0

        for item in Items:
            ItemsValue += getValue(item)
            ItemsWeight += getWeight(item)

        if ItemsWeight <= constraint and ItemsValue > optimalValue:
            optimalValue = ItemsValue
            optimalSet = Items

    return (optimalSet, optimalValue)


def bruteForceSolution():
    Items = buildItems()
    pset = buildPowerSet(Items)

    items, value = optimalItems(pset, 20,
                                Item.getValue,
                                Item.getWeight)

    print ('brute force : ' + str(value))
    for item in items:
        print ' ', item


# decision tree

def maxVal(items, avail):
    if items == [] or avail == 0:
        result = (0, ())
    elif items[0].getWeight() > avail:
        # do not take
        result = maxVal(items[1:], avail)
    else:
        current = items[0]
        # left branch : take the item
        leftValue, leftItems = maxVal(items[1:],
                                      avail - current.getWeight())
        leftValue += current.getValue()

        # right branch : do not take the item
        rightValue, rightItems = maxVal(items[1:],
                                        avail)

        if leftValue > rightValue:
            result = (leftValue, leftItems + (current,))
        else:
            result = (rightValue, rightItems)

    return result


def decisionTreeSolution():
    Items = buildItems()
    value, selected = maxVal(Items, 20)

    for item in selected:
        print item

    print ('decisition tree value : ' + str(value))

decisionTreeSolution()
