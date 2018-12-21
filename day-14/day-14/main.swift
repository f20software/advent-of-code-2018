//
//  main.swift
//  day-14
//
//  Created by Vladimir Svidersky on 12/13/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

// Initial state
// Will add numbers to this array
var r = [3, 7]
// Will also keep string to match last X digits for easy matching to string
var toMatch = "37"

// First elf index
var e1 = 0
// Second elf index
var e2 = 1

// Part 1 - generate receipes until we have x=input + 10 items
var max = 047801 + 10
// Part 2 - generate receipes until we have match string at the end
var match = "047801"

func nextStep(part: Int) -> Bool {
    var sum = r[e1] + r[e2]
    if sum > 9 {
        r.append(1)
        sum = sum - 10

        // Exit conditions
        if part == 1 {
            if r.count == max {
                return true
            }
        }
        else if part == 2 {
            if appendAndMatch(i: 1) {
                return true
            }
        }
    }
    r.append(sum)
    
    // Exit conditions
    if part == 1 {
        if r.count == max {
            return true
        }
    }
    else if part == 2 {
        if appendAndMatch(i: sum) {
            return true
        }
    }

    e1 = (e1 + 1 + r[e1]) % r.count
    e2 = (e2 + 1 + r[e2]) % r.count
    return false
}

func appendAndMatch(i: Int) -> Bool {
    toMatch.append("\(i)")
    if toMatch.count > match.count {
        toMatch.remove(at: toMatch.startIndex)
    }
    if toMatch == match {
        print("Part 2 is complete. \(toMatch) == \(match)")
        print("Total count = \(r.count). Pattern to match length is \(match.count)")
        return true
    }

    // Print progress... just in case
    if (r.count % 1000000 == 0) {
        print(r.count)
    }
    return false
}

func printData() {
    var out = ""
    for i in 0..<r.count {
        if i == e1 {
            out.append("(\(r[i])) ")
        }
        else if i == e2 {
            out.append("[\(r[i])] ")
        }
        else {
            out.append("\(r[i]) ")
        }
    }
    print(out)
}

func printLast10() {
    var out = ""
    for i in r.count-10..<r.count {
        out.append("\(r[i])")
    }
    
    print("Part 1 is complete. Last 10 numbers: \(out)")
}

func initialize() {
    r = [3, 7]
    toMatch = "37"
    e1 = 0
    e2 = 1
}

func doPart1() {
    initialize()
    while nextStep(part: 1) == false {}
    printLast10()
}

func doPart2() {
    initialize()
    while nextStep(part: 2) == false {}
}

doPart1()
doPart2()
// printData()

