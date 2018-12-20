//
//  main.swift
//  day-20
//
//  Created by Vladimir Svidersky on 12/20/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

struct Point: Hashable {
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
    
    var hashValue: Int {
        return x.hashValue ^ y.hashValue
    }

}

// Record min number of steps required to reach a room with X,Y coordinates
var points: [Point:Int] = [
    Point(x: 0, y: 0): 0
]

class Path {
    var point: Point
    var path: String
    var children = [Path]()
    var next: Path?
    
    init(point: Point) {
        self.point = point
        self.path = ""
    }

    var tree: String {
        var result = path
        if children.count > 0 {
            result.append("(")
            result.append(children.map({ $0.tree }).joined(separator: "|"))
            result.append(")")
        }
        if next != nil {
            result.append(next!.tree)
        }
        
        return result
    }
    
    var fullLength: Int {
        let nextLength: Int = (next != nil ? next!.fullLength: 0)

        if children.count == 0 {
            return path.count + nextLength
        }
        
        return children.map({ $0.fullLength }).reduce(0, +) + children.count + 1 + path.count + nextLength
    }

    // Returns how many characters we traversed
    func parse(_ str: String, startWith: String.Index) -> Int {
        
        var curPoint = point
        var curPointDistance = points[point]!
        var ind = startWith
 
        while "NEWS".contains(str[ind])  {
            switch str[ind] {
            case "N":
                curPoint = curPoint.up
            case "E":
                curPoint = curPoint.right
            case "W":
                curPoint = curPoint.left
            case "S":
                curPoint = curPoint.down
            default:
                break
            }
            
            curPointDistance = curPointDistance + 1
            if (points[curPoint] == nil || points[curPoint]! > curPointDistance) {
                print("Room \(curPoint.x), \(curPoint.y) can be reached in \(curPointDistance)")
                points[curPoint] = curPointDistance
            }
            
            path.append(str[ind])
            ind = str.index(after: ind)
        }
        
        if str[ind] == "(" {
            // Parse all children
            repeat {
                ind = str.index(after: ind)
                let child = Path(point: curPoint)
                let len = child.parse(str, startWith: ind)
                children.append(child)
                ind = str.index(ind, offsetBy: len)
            } while str[ind] == "|"
            
            // See if there anything left, i.e. if we need to add pointer to
            // the next Path segment - it could start with move character or
            // with "(" (for segment with empty path)
            ind = str.index(after: ind)
            if "NEWS(".contains(str[ind]) {
                let nextPath = Path(point: curPoint)
                self.next = nextPath
                _ = nextPath.parse(str, startWith: ind)
            }
            return fullLength
        }

        // Otherwise we're done - return full length, so the caller might adjust current index
        // in the input string
        return fullLength
    }
}

let input = puzzle
let startIndex = input.index(after: input.startIndex)

var p = Path(point: Point(x: 0, y: 0)).parse(input, startWith: startIndex)

print("Max: \(points.values.max()!)")
print(">=1000: \(points.values.filter({ $0 >= 1000 }).count)")


