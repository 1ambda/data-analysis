
def probTest(limit):
    n = 1
    prob = float(1) / 6

    while(prob >= limit):
        # prob * 5/6
        prob = prob * (float(5) / 6)
        n += 1

    return n

print probTest(0.167)
