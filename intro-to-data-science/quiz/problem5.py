import pylab
import random


def generateScores(trials):
    trials = 10000
    scores = []
    for t in range(trials):
        # Midterm 1: 50 <= grade <= 80, 25%
        # Midterm 2: 60 <= grade <= 90, 25%
        # Final Exam: 55 <= grade <= 95, 50%
        mid1 = random.choice(range(50, 81))
        mid2 = random.choice(range(60, 91))
        final = random.choice(range(55, 96))

        grade = float(mid1) * 1/4 + float(mid2) * 1/4 + float(final) * 1/2

        scores.append(grade)

    return scores


def subProblem1():
    trials = 10000
    scores = generateScores(trials)

    count = 0
    
    for s in scores:
        if 70 <= s and s <= 75:
            count += 1

    print count / float(trials)
    
def subProblem2():
    trials = 10000
    scores = generateScores(trials)

    pylab.figure()
    pylab.hist(scores, bins=7)
    pylab.xlabel("Final Score")
    pylab.ylabel("Number of Trials")
    pylab.title("Distribution of Scores")
    pylab.show()

subProblem2()
