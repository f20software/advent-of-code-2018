//
//  main.swift
//  day-14
//
//  Created by Vladimir Svidersky on 12/13/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

var r = [3, 7]
var e1 = 0
var e2 = 1
var max = 047801
var match = "047801"

var toMatch = "37"

func nextStep() -> Bool {
    var sum = r[e1] + r[e2]
    if sum > 9 {
        r.append(1)
        if appendAndMatch(i: 1) == true {
            return true
        }
        sum = sum - 10
    }
    r.append(sum)
    if appendAndMatch(i: sum) == true {
        return true
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
        print("END!!! \(toMatch) == \(match)")
        return true
    }
    // print(toMatch)
    if (r.count % 1000 == 0) {
        print(r.count)
    }
    return false
}

func found (match: String) -> Bool {
    if r.count < 7 {
        return false
    }

    var out = ""
    for i in r.count-5..<r.count {
        out.append("\(r[i])")
    }
    if out == match {
        return true
    }
    out = ""
    for i in r.count-6..<r.count-1 {
        out.append("\(r[i])")
    }
    if out == match {
        return true
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
    
    print(out)
}

while nextStep() == false {
}
print(r.count)
// printData()

