from collections import deque

def getSeeds(line):
    if not line.startswith("seeds: "):
        return []
    # build seed list
    seedsList = line[7:].split(' ')
    return [int(x) for x in seedsList]

def getSeedRanges(line):
    if not line.startswith("seeds: "):
        return []
    # build seed list
    seedsList = line[7:].split(' ')
    seeds = []
    for i in range(len(seedsList)//2):
        seeds.append((int(seedsList[i]), int(seedsList[i+1])))
    return seeds

dataMap = {}
currentKey = None
seeds = []
for line in open('./day-5-input.txt'):
    cleanedStr = line.strip()
    if len(cleanedStr) == 0:
        continue
    if cleanedStr.startswith("seeds: "):
        seeds = getSeedRanges(cleanedStr)
        continue
    
    if "map:" in cleanedStr:
        # start new ranges
        currentKey = cleanedStr[0:-4].strip()   
        dataMap[currentKey] = []
    else:
        # destination source amount
        segments = cleanedStr.split(' ')
        if len(segments) != 3:
            print("Error parsing line: %s" % cleanedStr)
            continue
        destination = int(segments[0])
        source = int(segments[1])
        amount = int(segments[2])
        sourceResults = dataMap[currentKey]
        sourceResults.append((source, destination, amount))
        dataMap[currentKey] = sourceResults

def getSeedLocation(seed, dataMap):
    DATA_MAP_PATH = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location"
    ]
    finalLocation = seed
    for k in DATA_MAP_PATH:
        if not k in dataMap:
            print("Error: missing map key %s" % k)
            return None
        for result in dataMap[k]:
            (source, destination, amount) = result
            sourceRange = range(source, source + amount)
            if finalLocation in sourceRange:
                finalLocation = finalLocation - source + destination
                break
        
    return finalLocation

def buildIntervals(dataMap):
    DATA_MAP_PATH = [
        "seed-to-soil",
        "soil-to-fertilizer",
        "fertilizer-to-water",
        "water-to-light",
        "light-to-temperature",
        "temperature-to-humidity",
        "humidity-to-location"
    ]
    def findIntersections(newInterval, oldInterval):
        (s, d, a) = oldInterval
        (s1, d1, a1) = newInterval
        if newInterval == oldInterval:
            return [newInterval], None
        
        overlap = range(max(s, s1), min(d + a, s1 + a1))

        intersections = []
        finalInterval = newInterval
        if len(overlap) > 0:
            print("\n    oldInterval: %s" % str(oldInterval))
            print("    newInterval: %s" % str(newInterval))
            print("    found overlap: %s" % overlap)
            # Split up the intervals
            leftRange = 0
            midRange = len(overlap)
            if d < s1:
                # --- s.d[0] -- o[0](s1[0]) -- o[-1](s.d[-1]) -- s1[-1] --
                leftRange = overlap[0] - d
                intersections.append((s, d, leftRange + midRange))
            else:
                leftRange = overlap[0] - s1
                intersections.append((s1, d1, leftRange))
                print("Inserted! %s" % intersections)

            print("Result: (%s) old vs (%s) new" % (d + a, s1 + a1))
            if d + a > s1 + a1:
                # update the result
                finalInterval = None # no more intervals to check
                rightRange = a - midRange
                if rightRange > 0:
                    intersections.append((overlap[-1] + 1, d + overlap[-1] - s + 1, rightRange))
            else:
                rightRange = a1 - midRange
                if rightRange > 0:
                    finalInterval = (overlap[-1] + 1, d1 + overlap[-1] - s1 + 1, rightRange)
        else:
            intersections.append(oldInterval)
        return intersections, finalInterval

    intervals = set()
    for k in DATA_MAP_PATH:
        sortedIntervals = list(intervals)
        sortedIntervals.sort(key=lambda x: x[0])
        print("\n=======\nCurrent intervals: \n=======\n")
        for i in sortedIntervals:
            print("%s" % str(i))
        if not k in dataMap:
            print("Error: missing map key %s" % k)
            return None
        
        results = deque([x for x in dataMap[k]])
        sorted(results, key=lambda x: (x[0], x[2]))
        if len(intervals) == 0:
            # populate the first set of intervals
            intervals.update(results)
            continue
    
        
        while results:
            updatedIntervals = set()
            print("\n---%s" % results)
            result = results.popleft()
            print("Result %s from %s..." % (str(result), k))
            sortedIntervals = list(intervals)
            sortedIntervals.sort(key=lambda x: x[0])
            # print("Existing intervals (sorted) %s...\n" % sortedIntervals)
            print("updating intervals now...")
            for i, oldResult in enumerate(sortedIntervals):
                if result is None:
                    updatedIntervals.update(sortedIntervals[i:])
                    break
                newIntervals, newResult = findIntersections(result, oldResult)
                if newResult != result:
                    print("Updated result: %s" % str(newResult))
                print("New intervals: %s (%s and %s)" % (newIntervals, result, oldResult))
                
                result = newResult
                updatedIntervals.update(newIntervals)
            
            print("Updated intervals: %s" % updatedIntervals)
            
            
            if result:
                print("     Adding result: %s" % str(result))
                updatedIntervals.add(result)
            intervals = updatedIntervals
                
            print("Final intervals: %s" % intervals)        
    return intervals

print(dataMap)
intervals = buildIntervals(dataMap)
sortedIntervals = list(intervals)
sortedIntervals.sort(key=lambda x: x[0])
print("------------------ intervals")
for r in sortedIntervals:
    print("%s" % str(r))

minLocation = float('inf')
for (s, r) in seeds:
    seedRange = range(s, s + r)
    for (source,dest,amount) in sortedIntervals:
        locationRange = range(source,source+amount)
        overlap = range(max(s, source), min(s+r, source+amount) + 1)
        if len(overlap) > 0:
            start_bounds = max(s, source)
            location = dest if start_bounds <= source else dest + start_bounds - s
            print("Lowest location %s for seed %s" % (location, s))
            if location < minLocation:
                minLocation = location
print("=====\nMin location: %s" % minLocation)
    