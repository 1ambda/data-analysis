
# Week2

**Map-Reduce** deals with failures and slow tasks by re-launching the tasks on other machines. This functionality is enabled by the requirement that individual tasks in a Map Reduce job are 

- **idempotent** and 
- have **no side effect**

Using memory instead of disks offers two huge benefits. 

- memory is much faster than disks
- Keeping intermediate results in memory means that they do not have to be converted into a format that can be stored on disks. The converting process requires serialization and de-serialization which are very expensive tasks.

<br/>

Spark powers a stack of high-level these tools.

![](https://spark.apache.org/images/spark-stack.png)
(Ref - https://spark.apache.org/)

![](https://courses.edx.org/c4x/BerkeleyX/CS100.1x/asset/History.png)
(Ref - https://courses.edx.org/courses/BerkeleyX/CS100.1x/1T2015/)

## Spark

[Ref - Apache Spark 101](http://www.slideshare.net/paulszulc/apache-spark-101-in-50-min)

[Ref - spark.apache.org](https://spark.apache.org/docs/1.3.0/cluster-overview.html)

![](https://spark.apache.org/docs/1.3.0/img/cluster-overview.png)

### Spark Context

- tells Spark how and where to access a cluster

### RDDs, Resilient Distributed Datasets

RDDs

- are **immutable**, in other words they can not be changed after constructed
- can be created by transformations applied to existing RDDs
- enable parallel operations on collections of distributed data
- track lineage information to enable efficient recomputation of lost data

All transformations in Spark are **lazy**, in that they do no compute their results right away. instead, they just remember the transformations applied to some base dataset. The transformations are only compueted when an action requires a result to be returned to the driver program. 

### Createing RDD


    data = [1, 2, 3, 4, 5]
    rdd = sc.parallelize(data, 4)
    rdd




    ParallelCollectionRDD[91] at parallelize at PythonRDD.scala:392




    distFile = sc.textFile("README.md", 4)
    distFile




    README.md MapPartitionsRDD[93] at textFile at NativeMethodAccessorImpl.java:-2



### Transformation

- `map`
- `filter`
- `distinct`
- `flatMap`

function literals (lambda) are clusures automatically passed to workers.


    rdd = sc.parallelize([1, 2, 3, 4])
    rdd.map(lambda x: x * 2).collect()




    [2, 4, 6, 8]




    rdd.filter(lambda x: x % 2 == 0).collect()




    [2, 4]




    rdd2 = sc.parallelize([1, 4, 2, 2, 3])
    rdd2.distinct().collect()




    [1, 2, 3, 4]




    rdd2.collect() # immutable




    [1, 4, 2, 2, 3]




    rdd2.distinct().map(lambda x: [x, x + 5]).collect()




    [[1, 6], [2, 7], [3, 8], [4, 9]]




    rdd3 = sc.parallelize([1, 2, 3])
    rdd3.flatMap(lambda x: [x, -x]).collect()




    [1, -1, 2, -2, 3, -3]



### Spark Actions

- cause Spark execute recipe to transform source
- is the primary mechanism for getting results out of Spark
- are not lazily evaluated

- `reduce`
- `take`
- `collect`
- `takeOrdered`

**nothing happens when we acually do that until we execute an action**

- Actions cause parallel computation to be **immediately executed**
- Transformations **lazily create** new RDDs


    rdd = sc.parallelize([1, 2, 3])
    rdd.reduce(lambda a, b: a * b)




    6




    rdd.take(2)




    [1, 2]




    rdd.collect()




    [1, 2, 3]




    rdd = sc.parallelize([5, 3, 1, 2])
    rdd.takeOrdered(3, lambda s: -1 * s)




    [5, 3, 2]




    ### Spark Programming Model


### Caching RDDs

```python
lines = sc.textFile("...", 4)
comments = lines.filter(isComment)
print lines.count(), comments.count() # comments.count will recompute `lines` to prevent this, we can use `cache`
```

```python
lines = sc.textFile("...", 4)
lines.cache

comments = lines.filter(isComment)
print lines.count(), comments.count()
```

### Spark Program Life-cycle

1. Create RDDs from external data or **paralleize** a collection in your driver program

2. Lazily **transform** them into new RDDs

3. `cache()` some RDDs for reuse

4. perform **actions** to execute parallel computation and produce result

### Spark Key-Value RDDs

- `reduceByKey`
- `sortByKey`
- `groupByKey`

Be careful using `groupByKey()` as it can cause a lot of data movement across the network and create large iterables at workers.


    rdd = sc.parallelize([(1, 2), (3, 4), (3, 6)])
    rdd.reduceByKey(lambda a, b: a + b).collect()




    [(1, 2), (3, 10)]




    rdd2 = sc.parallelize([(1, 'a'), (2, 'c'), (1, 'b')])
    rdd2.sortByKey().collect()




    [(1, 'a'), (1, 'b'), (2, 'c')]



### pySpark Closures

- one closure per work
- sent for every task
- changes to global variables at workers are not sent to the driver

The problem is, 

- closures are (re-)sent with **every** job
- inefficient to send large data to each worker
- closures are one way (driver -> worker)

### Broadcast

- efficiently send large, **read-only** value to all workers instead of to each task
- usually distributed using efficient broadcast algorithms



    broadcastVar = sc.broadcast([1, 2, 3])
    broadcastVar.value




    [1, 2, 3]



#### Broadcast Example

```python
signPrefixes = loadCallSignTable()

def processSignCount(sign_count, signPrefixes):
  country = lookupCountry(sign_count[0], signPrefixes)
  count = sign_count[1]
  return (country, count)
  
countryContactCounts = (contactCounts
                        .map(processSignCount)
                        .reduceByKey(lambda x, y: x + y))
```

We can improve above example using **broadcast**

```python
signPrefixes = broadcast(loadCallSignTable())

def processSignCount(sign_count, signPrefixes):
  country = lookupCountry(sign_count[0], signPrefixes.value)
  count = sign_count[1]
  return (country, count)
  
countryContactCounts = (contactCounts
                        .map(processSignCount)
                        .reduceByKey(lambda x, y: x + y))

```


### Accumulator

- aggregate values from workers back to driver
- only driver can access value of accumulator
- for tasks, accumulators are **write-only**

**accumulators can be used in actions or transformations**, but transformations: **no guarantees**.


    accum = sc.accumulator(0)
    rdd = sc.parallelize([1, 2, 3, 4])
    
    def f(x):
        global accum
        accum += x
        
    rdd.foreach(f)
    accum.value




    10



#### Accumulator Example

```python
  file = sc.textFile(input)
  blankLines = sc.accumulator(0)
    
def extractCallSigns(line):
  global blankLines
  
  if (line == ""):
    blankLines += 1
  
  return line.split(" ")
  
callSigns = file.flatMap(extractCallSigns)

print "Blank lines: %d" % blankLines.value
```


    


    
