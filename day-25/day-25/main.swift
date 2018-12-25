//
//  main.swift
//  day-25
//
//  Created by Vladimir Svidersky on 12/24/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

class Point {
    var x: Int
    var y: Int
    var z: Int
    var t: Int
    var con: Int
    
    init(data: [Int]) {
        x = data[0]
        y = data[1]
        z = data[2]
        t = data[3]
        con = -1
    }
    
    func distanceFrom(_ p: Point) -> Int {
        var res: Int = abs(self.x - p.x) + abs(self.y - p.y) + abs(self.z - p.z)
        res = res + abs(self.t - p.t)
            
        return res
    }
}

var input = puzzle
var points = [Point]()

func initialize() {
    for i in input {
        points.append(Point(data: i))
    }
}

func nextConst() -> Int {
    var maxConst = 0
    for p in points {
        if p.con > maxConst {
            maxConst = p.con
        }
    }
    return maxConst + 1
}

func mergeConst(from: Int, to: Int) {
    print("Merging \(from) -> \(to)")
    for p in points {
        if p.con == from {
            p.con = to
        }
    }
}

func assignConstellations() {
    
    points[0].con = 1
    for i in 1..<points.count {
        // Walk through all points that were assigned number before point[i]
        for j in 0..<i {
            // If it's closer then 3 and then we need to add it to a constellation
            if points[i].distanceFrom(points[j]) <= 3 {
                // If it has not been assigned - assigned same # from point[j]
                if points[i].con < 0 {
                    points[i].con = points[j].con
                }
                // Otherwise we need to merge two constellation together
                else {
                    mergeConst(from: points[i].con, to: points[j].con)
                }
            }
        }
        // If hasn't assigned # - get the next one
        if points[i].con < 0 {
            points[i].con = nextConst()
        }
    }
}

// Initialize points objects from the input array
initialize()
// Walk through them and assign constellation numbers - complexity O(N^2)
assignConstellations()

// Part 1:
// Print number of unique constellation numbers
let totalConst = points.map({ $0.con }).unique().count
print("Total number of constellations: \(totalConst)")


