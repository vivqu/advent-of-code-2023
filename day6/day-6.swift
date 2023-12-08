import Foundation

let fileName = "day-6-input.txt"
let data = try NSString(
    contentsOfFile: fileName,
    encoding: String.Encoding.ascii.rawValue
)

enum DataHandlingError: Error {
    case mismatchedRaceValues
    case cannotParse
}

// Tuple of (duration, record)
var races: [(Int, Int)] = []
let lines = data.components(separatedBy: "\n")
for line in lines {
    let cleanedLine = line.lowercased()
    let strComponents = cleanedLine.components(separatedBy: ": ")
    guard strComponents.count == 2 else { 
        print("Error: invalid number of string components (\(strComponents.count))")
        break
    }
    let values = strComponents[1].components(separatedBy: " ").filter { $0.count > 0 }
    if cleanedLine.contains("time") {
        // Processing all the times first
        races = values.map { if let val = Int($0) { (val, 0) } else { (0,0) } }
    } else if cleanedLine.contains("distance") {
        for i in 0..<values.count {
            if i >= races.count {
                throw DataHandlingError.mismatchedRaceValues
            }
            if let d = Int(values[i]) {
                let (t, _) = races[i]
                races[i] = (t, d)
            } else {
                throw DataHandlingError.cannotParse
            }
        }
    }
}
var product = 1
for (t,d) in races {
    
    // Find race values, excluding holding the
    // button the entire time
    var sum = 0
    for h in 1..<t {
        if (t - h) * h > d {
            sum += 1
        }
    }
    product *= sum
    print("\(t): \(d) - \(sum) ways")
    if sum == 0 {
        break
    }
}
print("\(product)")