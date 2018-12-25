//
//  main.swift
//  day-23
//
//  Created by Vladimir Svidersky on 12/22/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

class Bot {
    var x: Int
    var y: Int
    var z: Int
    var r: Int
    
    init(data: [Int]) {
        x = data[0]
        y = data[1]
        z = data[2]
        r = data[3]
    }
    
    func distanceFrom(b: Bot) -> Int {
        return abs(x - b.x) + abs(y - b.y) + abs(z - b.z)
    }
}

var bots = [Bot]()
let data = puzzle

// Initialize array of bots and return the one with max range
func initialize() -> Int {
    var maxr = 0
    var botind = -1
    for i in 0..<puzzle.count {
        let bot = Bot(data: puzzle[i])
        bots.append(bot)
        if bot.r > maxr {
            maxr = bot.r
            botind = i
        }
    }
    
    return botind
}

func printPart1(i: Int) {
    let bot = bots[i]
    print("Max R = \(bot.r)")
    
    var count = 0
    for j in 0..<bots.count {
        let b = bots[j]
        if b.distanceFrom(b: bot) <= bot.r {
            count = count + 1
        }
    }
    
    print("\(count) within range")
}

// This will not solve part2 - I was just trying to see
// how many bots are within the range of others
func tryPart2() {
    for i in 0..<bots.count {
        let bot = bots[i]
        var count = 0
        for j in 0..<bots.count {
            let b = bots[j]
            if b.distanceFrom(b: bot) <= bot.r {
                count = count + 1
            }
        }
        if count > 900 {
            print("\(i): \(count) within range")
        }
    }
}

let maxInd = initialize()
printPart1(i: maxInd)

// tryPart2()
