//
//  main.swift
//  day-17
//
//  Created by Vladimir Svidersky on 12/17/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

enum Direction: Int {
    case up = 0
    case left = 1
    case right = 2
    case down = 3
}

struct Point: Comparable {
    var x: Int
    var y: Int
    
    var up: Point {
        return Point(x: x, y: y-1)
    }
    var down: Point {
        return Point(x: x, y: y+1)
    }
    var left: Point {
        return Point(x: x-1, y: y)
    }
    var right: Point {
        return Point(x: x+1, y: y)
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
}

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}

var input = puzzle

var matrix = [String]()
var minx: Int?
var maxx: Int?
var miny: Int?
var origminy: Int?
var maxy: Int?
var width = 0
var height = 0

let charEmpty: Character = "."
let charWaterSpill: Character = "|"
let charWaterHold: Character = "~"
let charWall: Character = "#"

var water = [Point]()

func printMatrix() {
    for l in matrix {
        print(l)
    }
    print("")
}

func getPoint(_ p: Point) -> Character {
    let line = matrix[p.y-miny!]
    return line[line.index(line.startIndex, offsetBy: p.x-minx!)]
}

func isEmpty(_ p: Point) -> Bool {
    return getPoint(p) == charEmpty
}

func isWater(_ p: Point) -> Bool {
    let c = getPoint(p)
    return  c == charWaterHold || c == charWaterSpill
}

func isFilled(_ p: Point) -> Bool {
    let c = getPoint(p)
    return c == charWaterHold || c == charWall
}

func setPoint(_ p: Point, c: Character) {
    let line = matrix[p.y-miny!]
    let start = line.index(line.startIndex, offsetBy: p.x-minx!)
    let end = line.index(line.startIndex, offsetBy: p.x+1-minx!)
    matrix[p.y-miny!] = line.replacingCharacters(in: start..<end, with: "\(c)")
}

func buildMatrix() {
    // Get min..max ranges
    for l in input {
        var match = l.matchingStrings(regex: "x=([0-9]{1,4}), y=([0-9]{1,4})..([0-9]{1,4})")
        if match.count > 0 {
            let xval = Int(match[0][1])!
            if minx == nil || xval < minx! {
                minx = xval
            }
            if maxx == nil || xval > maxx! {
                maxx = xval
            }
            let ylow = Int(match[0][2])!
            let yhi = Int(match[0][3])!
            if miny == nil || ylow < miny! {
                miny = ylow
            }
            if maxy == nil || yhi > maxy! {
                maxy = yhi
            }
        }

        match = l.matchingStrings(regex: "y=([0-9]{1,4}), x=([0-9]{1,4})..([0-9]{1,4})")
        if match.count > 0 {
            let yval = Int(match[0][1])!
            if miny == nil || yval < miny! {
                miny = yval
            }
            if maxy == nil || yval > maxy! {
                maxy = yval
            }
            let xlow = Int(match[0][2])!
            let xhi = Int(match[0][3])!
            if minx == nil || xlow < minx! {
                minx = xlow
            }
            if maxx == nil || xhi > maxx! {
                maxx = xhi
            }
        }
    }
    minx = minx! - 2
    maxx = maxx! + 2
    origminy = miny!
    miny = 0
    width = (maxx! - minx!) + 1
    height = (maxy! - miny!) + 1
        
    print("x: \(minx!)..\(maxx!), y: \(miny!)..\(maxy!)")
    
    while matrix.count <= height {
        matrix.append(String(repeating: ".", count: width))
    }
    
    for l in input {
        var match = l.matchingStrings(regex: "x=([0-9]{1,4}), y=([0-9]{1,4})..([0-9]{1,4})")
        if match.count > 0 {
            let x = Int(match[0][1])!
            let ylow = Int(match[0][2])!
            let yhi = Int(match[0][3])!
            for y in ylow...yhi {
                setPoint(Point(x: x, y: y), c: "#")
            }
        }
        
        match = l.matchingStrings(regex: "y=([0-9]{1,4}), x=([0-9]{1,4})..([0-9]{1,4})")
        if match.count > 0 {
            let y = Int(match[0][1])!
            let xlow = Int(match[0][2])!
            let xhi = Int(match[0][3])!
            for x in xlow...xhi {
                setPoint(Point(x: x, y: y), c: charWall)
            }
        }
    }

}

func fillDownFrom(_ p: Point) -> Bool {
    
    // print("Filling from \(p)")
    // printMatrix()
    setPoint(p, c: charWaterSpill)
    if p.down.y <= maxy! && isEmpty(p.down) {
        let spilled = fillDownFrom(p.down)
        if spilled {
            return true
        }
    }

    if p.down.y <= maxy! && getPoint(p.down) == charWaterSpill {
        return true
    }

    
    
    if p.down.y <= maxy! {
        var spilledL = false
        var spilledR = false
        
        // Go right...
        var nextL = p.left
        while nextL.x > minx! && isEmpty(nextL) && isFilled(nextL.down) {
            setPoint(nextL, c: "|")
            nextL = nextL.left
        }
        if nextL.x > minx! && isEmpty(nextL) {
            spilledL = fillDownFrom(nextL)
        }
        var nextR = p.right
        while nextR.x <= maxx! && isEmpty(nextR) && isFilled(nextR.down) {
            setPoint(nextR, c: "|")
            nextR = nextR.right
        }
        if nextR.x <= maxx! && isEmpty(nextR) {
            spilledR = fillDownFrom(nextR)
        }
        
        // If we didn't spill - go and update all points with ~
        if spilledL == false && spilledR == false {
            nextL = nextL.right
            while nextL != nextR {
                setPoint(nextL, c: charWaterHold)
                nextL = nextL.right
            }
            return false
        }
        
        if spilledL == true && spilledR == false {
            nextR = p
            while getPoint(nextR) != charWall {
                setPoint(nextR, c: charWaterSpill)
                nextR = nextR.right
            }
        }

        if spilledR == true && spilledL == false {
            nextL = p
            while getPoint(nextL) != charWall && nextL.x > minx! {
                setPoint(nextL, c: charWaterSpill)
                nextL = nextL.left
            }
        }

        return true
    }
    
    return true
}


func countWater() {
    var count = 0
    for x in minx!...maxx! {
        for y in origminy!...maxy! {
            //if isWater(Point(x: x, y: y)) {
            if getPoint(Point(x: x, y: y)) == charWaterHold
            {
                count = count + 1
            }
            
        }
    }
    print("TOTAL HOLD WATER: \(count)")
}

buildMatrix()
printMatrix()

_ = fillDownFrom(Point(x: 500, y: 0))

printMatrix()
countWater()





