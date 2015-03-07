import random


def strToInt(s):
    number = ''

    for c in s:
        number = number + str(ord(c))

    index = int(number)
    return index


def hashStr(s, tableSize):
    number = ''

    for c in s:
        number = number + str(ord(c))

    index = int(number) % tableSize
    return index

print strToInt('John is cool')
print hashStr('John is cool', 101)


class intDict(object):
    def __init__(self, numBuckets):
        """Create an empty dict"""
        self.buckets = []
        self.numBuckets = numBuckets
        for i in range(numBuckets):
            self.buckets.append([])

    def addEntry(self, key, val):
        """dictKey is an int"""
        hashBucket = self.buckets[key % self.numBuckets]

        for i in range(len(hashBucket)):
            if hashBucket[i][0] == key:
                hashBucket[i] = (key, val)
                return

        hashBucket.append((key, val))

    def getValue(self, key):
        hashBucktet = self.buckets[key % self.numBuckets]

        for tuple in hashBucktet:
            if tuple[0] == key:
                return tuple[1]

        return None

    def __str__(self):
        res = '{'
        for b in self.buckets:
            for t in b:
                res = res + str(t[0]) + ':' + str(t[1]) + ','

        # res[:-1] removes the last element
        return res[:-1] + '}'

D = intDict(29)

for i in range(200):
    key = random.choice(range(10 ** 5))
    D.addEntry(key, i)

print '\n', 'The buckets are'

for b in D.buckets:
    print '  ', b
