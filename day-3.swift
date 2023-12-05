import Foundation

let fileName = "day-3-input.txt"
let data = try NSString(contentsOfFile: fileName, encoding: String.Encoding.ascii.rawValue)

func getMatrix() -> [String] {
    let lines = data.components(separatedBy: "\n")
    var matrix: [String] = []
    guard let lineLength = lines.first?.count else { 
        print("Error: No lines found")
        return []
    }

    for line in lines {
        if line.count != lineLength {
            print("Error: Line length mismatch")
            return []
        }
        matrix.append(line)
    }
    return matrix
}

func checkForSymbol(_ num: Int, row: Int, column: Int, matrix: [String], allSymbols: Bool = true) -> (Bool, (Int, Int)) {
    // column is the index of the last digit in the list
    guard let lineLength = matrix.first?.count else {
        print("Error: No lines found")
        return (false, (0,0))
    }
    let numDigits = String(num).count
    let checkLeft = column - numDigits > 0
    let checkRight = column < lineLength - 1
    let startBounds = column - numDigits + 1 - (checkLeft ? 1 : 0)
    let endBounds = column + (checkRight ? 1 : 0)
    func checkLine(_ line: String) -> (Bool, Int) {
        let startIdx = String.Index(utf16Offset: startBounds, in: line)
        let endIdx = String.Index(utf16Offset: endBounds, in: line)
        let adjacentChars = line[startIdx...endIdx]
        for (idx, c) in adjacentChars.enumerated() {
            if allSymbols && c != "." && c.wholeNumberValue == nil {
                return (true, startBounds + idx)
            } else if !allSymbols && c == "*" {
                return (true, startBounds + idx)
            }
        }
        return (false, 0)
    }
        
    if row > 0 {
        // check above
        let prevLine = matrix[row - 1]
        let (hasSymbol, idx) = checkLine(prevLine)
        if hasSymbol {
            return (true, (row - 1, idx))
        }
    }
    if row < matrix.count - 1 {
        // check below
        let nextline = matrix[row + 1]
        let (hasSymbol, idx) = checkLine(nextline)
        if hasSymbol {
            return (true, (row + 1, idx))
        }
    }
    let currentLine = matrix[row]
    if checkLeft {
        // check left
        let idx = String.Index(utf16Offset: column - numDigits, in: currentLine)
        let leftChar = currentLine[idx]
        if allSymbols && leftChar != "." && leftChar.wholeNumberValue == nil {
            return (true, (row, column - numDigits))
        } else if !allSymbols && leftChar == "*" {
            return (true, (row, column - numDigits))
        }
    }
    if checkRight {
        // check right
        let idx = String.Index(utf16Offset: column + 1, in: currentLine)
        let rightChar = currentLine[idx]
        if rightChar != "." && rightChar.wholeNumberValue == nil {
            return (true, (row, column + 1))
        } else if !allSymbols && rightChar == "*" {
            return (true, (row, column + 1))
        }
    }
    return (false, (0,0))
}

func FirstSolution() {
    let matrix = getMatrix()
    guard let lineLength = matrix.first?.count else { 
        print("Error: No lines found")
        return
    }
    var sum = 0
    for (idx, line) in matrix.enumerated() {
        print("-----\n\(idx): \(line)")
        // iterate through each character and collect the numbers
        var currentNum = 0;
        for (cidx, c) in line.enumerated() {
            if let num = c.wholeNumberValue {
                currentNum = currentNum * 10 + num;
            } else {
                if currentNum != 0 {
                    let (hasSymbol, _) = checkForSymbol(currentNum, row: idx, column: cidx - 1, matrix: matrix)
                    if hasSymbol {
                        print("== Symbol found for \(currentNum)")
                        sum += currentNum
                    }
                    currentNum = 0
                }
            }
        }
        if currentNum != 0 {
            let (hasSymbol, _) = checkForSymbol(currentNum, row: idx, column: lineLength - 1, matrix: matrix)
            if hasSymbol {
                print("== Symbol found for \(currentNum)")
                sum += currentNum
            }
        }
    }
    print("Sum of all valid numbers: \(sum)")
}

func SecondSolution() {
    let matrix = getMatrix()
    guard let lineLength = matrix.first?.count else { 
        print("Error: No lines found")
        return
    }
    var sum = 0
    var starsMap: [String: [Int]] = [:]
    for (idx, line) in matrix.enumerated() {
        print("-----\n\(idx): \(line)")
        // iterate through each character and collect the star numbers
        var currentNum = 0;
        for (cidx, c) in line.enumerated() {
            if let num = c.wholeNumberValue {
                currentNum = currentNum * 10 + num;
            } else {
                if currentNum != 0 {
                    let (hasSymbol, starIdx) = checkForSymbol(currentNum, row: idx, column: cidx - 1, matrix: matrix)
                    if hasSymbol {
                        print("== Star found for \(currentNum) at \(starIdx)")
                        let mapKey = "\(starIdx)"
                        if starsMap[mapKey] == nil {
                            starsMap[mapKey] = [currentNum]
                        } else if var arr = starsMap[mapKey] {
                            arr.append(currentNum)
                            starsMap[mapKey] = arr
                        }
                    }
                    currentNum = 0
                }
            }
        }
        if currentNum != 0 {
            let (hasSymbol, starIdx) = checkForSymbol(currentNum, row: idx, column: lineLength - 1, matrix: matrix)
            if hasSymbol {
                print("== Star found for \(currentNum) at \(starIdx)")
                let mapKey = "\(starIdx)"
                if starsMap[mapKey] == nil {
                    starsMap[mapKey] = [currentNum]
                } else if var arr = starsMap[mapKey] {
                    arr.append(currentNum)
                    starsMap[mapKey] = arr
                }
            }
        }
    }
    print(starsMap)
    for (key, value) in starsMap {
        if value.count > 1 {
            let product = value.reduce(1, *)
            print("Found gear at \(key): \(value) = \(product)")
            sum += product
        }
    }
    
    print("Sum of all valid gears: \(sum)")
}

// FirstSolution()
SecondSolution()