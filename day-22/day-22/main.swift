//
//  main.swift
//  day-22
//
//  Created by Vladimir Svidersky on 12/21/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

let kRocky = 0
let kWet = 1
let kNarrow = 2

// Structure to hold minimal number of minute it would
// take to reach certain point with various tools
struct Reach: Equatable {
    var withEmpty: Int?
    var withTorch: Int?
    var withGear: Int?
    
    static func == (lhs: Reach, rhs: Reach) -> Bool {
        return lhs.withTorch == rhs.withTorch && lhs.withGear == rhs.withGear && lhs.withEmpty == rhs.withEmpty
    }
}

// Add some padding to the matrix, so we can explore
// path beyound target coordinates
var maxX = targetX + padding
var maxY = targetY + padding

var matrix = [[Int]]()
var opt = [[Reach]]()

func initialize() {
    for _ in 0...maxY {
        matrix.append(Array(repeating: 0, count: maxX + 1))
        opt.append(Array(repeating: Reach(withEmpty: nil, withTorch: nil, withGear: nil), count: maxX + 1))
    }
}

func fillMatrix() {
    for y in 0...maxY {
        for x in 0...maxX {
            var geo = 0
            if x == targetX && y == targetY {
                geo = 0
            }
            else if x == 0 && y > 0 {
               geo = y * 48271
            }
            else if y == 0 && x > 0 {
                geo = x * 16807
            }
            else if x > 0 && y > 0 {
                geo = matrix[y-1][x] * matrix[y][x-1]
            }
            matrix[y][x] = (geo + depth) % modulo
        }
    }
    for y in 0...maxY {
        for x in 0...maxX {
            matrix[y][x] = matrix[y][x] % 3
        }
    }
    matrix[0][0] = 0
}

func printMatrix() {
    for y in 0...maxY {
        var line = ""
        for x in 0...maxX {
            if x == targetX && y == targetY {
                line.append("T")
                continue
            }
            switch (matrix[y][x] % 3) {
            case kRocky:
                line.append(".")
            case kWet:
                line.append("=")
            case kNarrow:
                line.append("|")
            default:
                break
            }
        }
        print(line)
    }
}

func riskLevel() -> Int {
    var result = 0
    for y in 0...targetY {
        for x in 0...targetX {
            result = result + matrix[y][x]
        }
    }
    return result
}

func reachOnePoint(current: Reach, condition: Int, from: Reach, fromCond: Int) -> Reach {

    var to = current
    
    let longTime = 1000000000
    var toGear: Int? = from.withGear ?? longTime
    var toTorch: Int? = from.withTorch ?? longTime
    var toEmpty: Int? = from.withEmpty ?? longTime
    
    if fromCond == kNarrow {
        if from.withTorch != nil {
            toEmpty = min(toEmpty!, from.withTorch! + switchTime)
        }
        if from.withEmpty != nil {
            toTorch = min(toTorch!, from.withEmpty! + switchTime)
        }
    }
    if fromCond == kRocky {
        if from.withTorch != nil {
            toGear = min(toGear!, from.withTorch! + switchTime)
        }
        if from.withGear != nil {
            toTorch = min(toTorch!, from.withGear! + switchTime)
        }
    }
    if fromCond == kWet {
        if from.withEmpty != nil {
            toGear = min(toGear!, from.withEmpty! + switchTime)
        }
        if from.withGear != nil {
            toEmpty = min(toEmpty!, from.withGear! + switchTime)
        }
    }
    
    // Final minimal time to reach current point from "to" point with
    // all gears (including +1 for moving to the current point)
    toGear = toGear == longTime ? nil : toGear! + 1
    toTorch = toTorch == longTime ? nil : toTorch! + 1
    toEmpty = toEmpty == longTime ? nil : toEmpty! + 1

    switch condition {
    case kRocky:
        if toGear != nil && (to.withGear == nil || to.withGear! > toGear!) {
            to.withGear = toGear!
        }
        if toTorch != nil && (to.withTorch == nil || to.withTorch! > toTorch!) {
            to.withTorch = toTorch!
        }

    case kWet:
        if toGear != nil && (to.withGear == nil || to.withGear! > toGear!) {
            to.withGear = toGear!
        }
        if toEmpty != nil && (to.withEmpty == nil || to.withEmpty! > toEmpty!) {
            to.withEmpty = toEmpty!
        }

    case kNarrow:
        if toTorch != nil && (to.withTorch == nil || to.withTorch! > toTorch!) {
            to.withTorch = toTorch!
        }
        if toEmpty != nil && (to.withEmpty == nil || to.withEmpty! > toEmpty!) {
            to.withEmpty = toEmpty!
        }

    default:
        break
    }
    
    return to
}

func findOptimalWay() {
    let zero = Reach(withEmpty: nil, withTorch: 0, withGear: 7)
    opt[0][0] = zero
    var gotBetter = false

    repeat {
        gotBetter = false
        // print("Looking for optimal solution...")
        
        for y in 0...maxY {
            for x in 0...maxX {
                var cur = opt[y][x]
                let cond = matrix[y][x]
                
                if x > 0 {
                    cur = reachOnePoint(current: cur, condition: cond, from: opt[y][x-1], fromCond: matrix[y][x-1])
                }
                if x < maxX {
                    cur = reachOnePoint(current: cur, condition: cond, from: opt[y][x+1], fromCond: matrix[y][x+1])
                }
                if y > 0 {
                    cur = reachOnePoint(current: cur, condition: cond, from: opt[y-1][x], fromCond: matrix[y-1][x])
                }
                if y < maxY {
                    cur = reachOnePoint(current: cur, condition: cond, from: opt[y+1][x], fromCond: matrix[y+1][x])
                }

                if cur != opt[y][x] {
                    opt[y][x] = cur
                    // print("I can reach \(x),\(y) withEmpty: \(cur.withEmpty ?? -1), withGear: \(cur.withGear ?? -1), withTorch: \(cur.withTorch ?? -1)")
                    gotBetter = true
                }
            }
        }
    } while (gotBetter == true)
}

initialize()
fillMatrix()

// Part 1
printMatrix()
print("Risk level: \(riskLevel())")

// Part 2
findOptimalWay()
let target = opt[targetY][targetX]
print("I can reach \(targetX),\(targetY) withEmpty: \(target.withEmpty ?? -1), withGear: \(target.withGear ?? -1), withTorch: \(target.withTorch ?? -1)")


