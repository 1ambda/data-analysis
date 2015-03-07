def fib(n):
    assert type(n) == int and n >= 0

    if n == 0 or n == 1:
        return 1
    else:
        return fib(n-1) + fib(n-2)


def testFib(n):
    assert type(n) == int and n >= 0

    for i in range(n):
        print ('fib of', i, '=', fib(i))


def fastFib(n, memo):
    assert type(n) == int and n >= 0

    if n == 0 or n == 1:
        return 1

    if n in memo:
        return memo[n]

    result = fastFib(n-1, memo) + fastFib(n-2, memo)
    memo[n] = result
    return result


def testFastFib(n):
    assert type(n) == int and n >= 0

    for i in range(n):
        print ('fast fib of', i, '=', fastFib(i, {}))

testFastFib(40)
