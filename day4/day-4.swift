import Foundation

let fileName = "day-4-input.txt"
let data = try NSString(
    contentsOfFile: fileName,
    encoding: String.Encoding.ascii.rawValue
)

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

func getPoints(_ card: String) -> Int {
    let power = getWinningCards(card)
    return power > 0 ? Int(truncating: NSDecimalNumber(decimal: pow(2, power - 1))) : 0
}

func ScratchCard() {
    let cards = data.components(separatedBy: "\n")
    var sum = 0
    for card in cards {
        let cardComponents = card.components(separatedBy: ":")
        guard cardComponents.count == 2 else { continue }
        let card = cardComponents[1]
        let points = getPoints(card)
        sum += points
    }
    print("Sum of winning cards: \(sum)")
}

// ScratchCard()

func MoreScratchCards() {
    let cards = data.components(separatedBy: "\n")
    let totalCards = cards.count
    var cardCountMap: [Int: Int] = Dictionary(
        uniqueKeysWithValues: zip(1...totalCards, repeatElement(1, count: totalCards))
    )

    for card in cards {
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
            guard winningCount > 0 && winningCount <= 10,
                let currentCount = cardCountMap[cardIndex] else {
                continue
            }
            if cardIndex + winningCount > totalCards {
                print("Error, too many cards: \(cardIndex) + \(winningCount) > \(totalCards)")
            }
            for i in 0..<winningCount {
                if let cardCount = cardCountMap[cardIndex + i] {
                    cardCountMap[cardIndex + i + 1] = currentCount + cardCount
                }
            }
        } catch {
            print("Error: \(error)")
            continue
        }
    }
    var sum = 0
    // Print in order for easier debugging
    let keys = Array(cardCountMap.keys).sorted(by: <)
    for k in keys {
        if let aggregate = cardCountMap[k] {
            sum += aggregate
        }
    }
    print("Total scratchcards: \(sum)")
}

MoreScratchCards()