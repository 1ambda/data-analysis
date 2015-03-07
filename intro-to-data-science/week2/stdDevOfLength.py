def stdDevOfLength(xs):
    if xs == []:
        return float('Nan')

    ys = []
    for x in xs:
        ys.append(len(x))

    mean = sum(ys) / float(len(ys))
    total = 0.0
    for y in ys:
        total += (y - mean) ** 2

    return (total / len(ys)) ** 0.5

print stdDevOfLength(['a', 'b', 'c'])
print stdDevOfLength(['apples', 'oranges', 'kiwis', 'pineapples'])
