def CV(xs):
    mean = sum(xs) / float(len(xs))
    if mean == 0:
        return float('Nan')

    return stdDev(xs) / mean


def stdDev(xs):
    mean = sum(xs)/float(len(xs))
    total = 0.0
    for x in xs:
        total += (x - mean) ** 2
    return (total / len(xs)) ** 0.5

print CV([10, 4, 12, 15, 20, 5])
