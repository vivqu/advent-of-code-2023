
time = 0
distance = 0
for line in open('./day-6-input.txt'):
    cleanedLine = line.lower()
    if "time" in cleanedLine:
        time = int(line.split(": ")[1].replace(" ", ""))
    elif "distance" in cleanedLine:
        distance = int(line.split(": ")[1].replace(" ", ""))
    else:
        print("Error!")

print("Time: %s" % time)
print("Distance: %s" % distance)

# Find minimum distance
min_result = 0
for i in range(1, time):
    result = (time - i) * i
    if result > distance:
        min_result = i
        break
max_result = time - 1
for i in reversed(range(min_result + 1, time)):
    result = (time - i) * i
    if result > distance:
        max_result = i
        break


print("Min result: %s" % min_result)
print("Max result: %s" % max_result)
print("Total ways: %s" % (max_result - min_result + 1))