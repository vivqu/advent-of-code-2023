import Foundation

let fileName = "day-4-input.txt"
let data = try NSString(contentsOfFile: fileName, encoding: String.Encoding.ascii.rawValue)

func getPoints(_ card: String) -> Int {
    let cardComponents = card.components(separatedBy: "|")
    guard cardComponents.count == 2 else { return 0 }
    let winningNumStr = cardComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
    let scratchNumStr = cardComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)
    let winningNums = winningNumStr.components(separatedBy: " ").map { Int($0) ?? -1 }
    let winningNumsSet = Set(winningNums)
    let scratchNums = scratchNumStr.components(separatedBy: " ").map { Int($0) ?? -1 }

    var power = 0
    for num in scratchNums {
        if num == -1 {
            continue
        }
        if winningNumsSet.contains(num) {
            power += 1
        }
    }
    return power > 0 ? Int(truncating: NSDecimalNumber(decimal: pow(2, power - 1))) : 0
}

func ScratchCard() {
    let cards = data.components(separatedBy: "\n")
    var sum = 0
    for card in cards {
        let cardComponents = card.components(separatedBy: ":")
        guard cardComponents.count == 2 else { continue }
        // let cardNumStr = cardComponents[0]
        let card = cardComponents[1]
        let points = getPoints(card)
        // print("\(cardNumStr): \(points)")
        sum += points
    }
    print("Sum of winning cards: \(sum)")
}

// ScratchCard()


func getWinningCards(_ card: String) -> Int {
    let cardComponents = card.components(separatedBy: "|")
    guard cardComponents.count == 2 else { return 0 }
    let winningNumStr = cardComponents[0]
    let scratchNumStr = cardComponents[1]
    let winningNums = winningNumStr.components(separatedBy: " ").map { Int($0) ?? -1 }
    let winningNumsSet = Set(winningNums)
    let scratchNums = scratchNumStr.components(separatedBy: " ").map { Int($0) ?? -1 }
    var cardCount = 0
    for num in scratchNums {
        if num == -1 {
            continue
        }
        if winningNumsSet.contains(num) {
            cardCount += 1
        }
    }
    return cardCount
}

func MoreScratchCards() {
    let cards = data.components(separatedBy: "\n")
    let totalCards = cards.count
    var cardMap: [Int: Set<Int>] = [:]

    for card in cards {
        print(card)
        let cardComponents = card.components(separatedBy: ":")
        guard cardComponents.count == 2 else { continue }
        let cardNumStr = cardComponents[0]
        let card = cardComponents[1]
        do {
            let regex = try NSRegularExpression(pattern: "Card\\s+(\\d+)")
            let results = regex.matches(in: cardNumStr, range: NSRange(cardNumStr.startIndex..., in: cardNumStr))
            guard let result = results.first,
                let range = Range(result.range(at: 1), in: cardNumStr),
                let cardIndex = Int(cardNumStr[range]) else {
                continue
            }
            let winningCount = getWinningCards(card)
            if winningCount > 0 && winningCount <= 10 {
                if cardIndex + winningCount > totalCards {
                    print("Error, too many cards: \(cardIndex) + \(winningCount) > \(totalCards)")
                }
                cardMap[cardIndex] = Set([Int](cardIndex + 1...cardIndex + winningCount))
            }
        } catch {
            print("Error: \(error)")
            continue
        }
    }
    var dynamicCount: [Int: Int] = [:]
    for i in stride(from: totalCards, to: 0, by: -1) {
        if let winningCards = cardMap[i] {
            var sum = 1
            for c in winningCards {
                sum += dynamicCount[c] ?? 0
            }
            dynamicCount[i] = sum
        } else {
            dynamicCount[i] = 1
        }
    }

    var sum = 0
    let keys = Array(dynamicCount.keys).sorted(by: <)
    for k in keys {
        if let aggregate = dynamicCount[k] {
            sum += aggregate
        }
    }
    print("Total scratchcards: \(sum)")
}

MoreScratchCards()