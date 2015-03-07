def power2Set(items):
    # 2^n
    n = len(items)

    for i in xrange(2 ** n):
        combo = []
        for j in xrange(n):
            if (i >> j) == 1:
                combo.append(items[j])

            yield combo


def power3Set(items):
    # 3^n
    n = len(items)

    for i in xrange(3 ** n):
        combo1 = []
        combo2 = []
        for j in xrange(n):
            shifted = (i / (3 ** j)) % 3

            if shifted == 1:
                combo1.append(items[j])
            elif shifted == 2:
                combo2.append(items[j])

            yield (combo1, combo2)
