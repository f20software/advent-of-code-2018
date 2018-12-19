//
//  main.swift
//  day-3
//
//  Created by Vladimir Svidersky on 12/19/18.
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

class Claim {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
    
    init(_ s: String) {
        // 150,916: 17x10"
        var match = s.matchingStrings(regex: "([0-9]{1,4}),([0-9]{1,4}): ([0-9]{1,4})x([0-9]{1,4})")
        if match.count > 0 {
            self.x = Int(match[0][1])!
            self.y = Int(match[0][2])!
            self.width = Int(match[0][3])!
            self.height = Int(match[0][4])!
        }
        else {
            abort()
        }
    }
}

let input = puzzle
var claims = [Claim]()

for line in input {
    claims.append(Claim(line))
}

var minx = claims.map({ $0.x }).min()!
var miny = claims.map({ $0.y }).min()!
var maxx = claims.map({ $0.x + $0.width }).max()!
var maxy = claims.map({ $0.y + $0.height }).max()!
var width = (maxx - minx) + 1
var height = (maxy - miny) + 1

var matrix = [String]()

func getPoint(_ p: Point) -> Character {
    let line = matrix[p.y-miny]
    return line[line.index(line.startIndex, offsetBy: p.x-minx)]
}

func setPoint(_ p: Point, c: Character) {
    let line = matrix[p.y-miny]
    let start = line.index(line.startIndex, offsetBy: p.x-minx)
    let end = line.index(line.startIndex, offsetBy: p.x+1-minx)
    matrix[p.y-miny] = line.replacingCharacters(in: start..<end, with: "\(c)")
}

func printMatrix() {
    for l in matrix {
        print(l)
    }
    print("")
}


print("x: \(minx)..\(maxx), y: \(miny)..\(maxy)")

while matrix.count <= height {
    matrix.append(String(repeating: ".", count: width))
}

var doubleBooked = 0

for c in claims {
    for y in c.y..<(c.y+c.height) {
        for x in c.x..<(c.x+c.width) {
            let p = Point(x: x, y: y)
            let c = getPoint(p)
            if c == "." {
                setPoint(p, c: "#")
            }
            else if c == "#" {
                setPoint(p, c: "X")
                doubleBooked = doubleBooked + 1
            }
        }
    }
}

printMatrix()
print(doubleBooked)

for i in 0..<claims.count {
    let c = claims[i]
    var foundDouble = false
    
    for y in c.y..<(c.y+c.height) {
        if foundDouble {
            break
        }
        for x in c.x..<(c.x+c.width) {
            let p = Point(x: x, y: y)
            let c = getPoint(p)
            if c != "#" {
                foundDouble = true
                break
            }
        }
    }
    
    if foundDouble == false {
        print("FOUND \(i+1)")
    }
}





