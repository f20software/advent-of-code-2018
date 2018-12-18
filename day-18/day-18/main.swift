//
//  main.swift
//  day-18
//
//  Created by Vladimir Svidersky on 12/17/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

let test = [
    ".#.#...|#.",
    ".....#|##|",
    ".|..|...#.",
    "..|#.....#",
    "#.#|||#|#|",
    "...#.||...",
    ".|....|...",
    "||...#|.#|",
    "|.||||..|.",
    "...#.|..|."
]

let puzzle = [
    ".||....##....|#|#.....|||...|............|......#.",
    "#....|#|..#....#....|...#.||...||..|||#|..#..|.##.",
    ".#|##|.#.|#|..|||....#|..|....|.##.#||#.|.#|..|..|",
    "|...|#.|...#..|...|#.|.#...##....|.||#...|...|...#",
    ".....|..#||..........###...#.||.###.|..#|#||..|#..",
    "|||.|##...|.|||#......###....|#.#|...|.#..|.|.|##.",
    ".......|.####.||##|.##....#............||#..#..|..",
    "..#|.|....#..|...|||..|...............|.|#..|.||#.",
    ".||#.#||.|.|.#.#|....#.#|..|.|#|.|.....|.#...|#..#",
    "......#..|...#....||#.#.#|..#...#.|||||..|#....|#|",
    "#.#|..#|#||#|||..#...#.........|.|..#...|......|.#",
    "|....|#..|##.....|...||.#....#......#...|..|#|#..#",
    ".|##.|...|......##.##.........#.#..|.||........|..",
    ".#||#.#...|.|.|.#|.#..|.|#..|##.|..|#....##.||....",
    "...|..|.#........#.|###|.#|...||.#....|..#.....#|.",
    "........#.###..###.....#....#|#|...#||..|..|....#|",
    ".|...........||.|...#|..|#....#|.#..|#..|..|.|.|..",
    "#.#..|.|||....|.....#|#...##.#......|..|..#..#.#|#",
    ".#|.#.........|.....##|##.#.#...#|...........#|#..",
    "..##|.|.|.##|.##..|..|...#|#..|.....|.|.#...#...||",
    ".|||..#.#.|.|#......####.........#|.|.#|.|.|.#.|..",
    "|#...|.........#.##..|....|....#|...||.#.|...|#.|#",
    "##.|.#..|#|#|#.|#.|##|..#.|..##.#....##.#...#|.|..",
    ".||#..#.#....|.#.#..#|.|.#|##|#.#||....#....#...|.",
    "#...#...|.|||.....#.|.#|..#......#.#...#.#|...|#||",
    "...##...|.#.##..||..#|.....|....#.##.#.|..|.|#.#.|",
    "..#..|...#.|..#......||....#.#|..##|.#....#.|.|...",
    "||.....|..|##.....##......#|.......|##.|.#.|.#.|..",
    "#|.|...|.|#...|...........#......|......|...#|.#..",
    "#|###|..#.##.||..#....|####.#.......#|..|...|.....",
    "........#.|.........#..##.#.#...|.#.....|.|.#.#|#.",
    ".##.##.#.|#|..#.###|...#....|#.|#.#|#....#.|...|..",
    "||...#......|||..#.|.||.|.|#..........#...#.|.|..#",
    "|.....|..|....#|.#|.#...|#..|#|#..#.###.|.....#.#.",
    "..#...|#..#...|||..###.|#.|..|......|.||....#.....",
    ".##.#||..#....#.#.|..|.....#...|..#.|....#..##..||",
    "........#..............#.||.#........|.|...|.|....",
    "..#.#..##..|.|..|#....||#...|.#...#|..|##..|...##|",
    "......#|##..#..........#...||.#|.||.|..|..|....|.#",
    "##..|.##|..#|#|#.|....|.#|..|#.#...#..##|#.##|.|..",
    "|...#.|.#.#..|..|....|#||...#..#....#..#|.......#.",
    "....#.###.#.|.....#.|.#.#.#...|.#|#...#|.....|.##.",
    "#......#..#.|.....||.#..|....|...#|||....|..|#.|..",
    "..|.#|##...#.#..#|...|........||#.#.#||.|#.#|#...|",
    "...|.|.#...|.|.....###|#.##|.#.....#|..|#|#|#.|#|.",
    ".##..|#.#..#....|#....|..|.||.#|..|.|.|.|..#.#.|..",
    ".#..|.|##||...|......|...#..#|.#....#...#|||...||.",
    ".|#.#....|#.#|.|....||.||.##|#...#.||.#.......#|..",
    "#...||.....|.|...|||...||....#..#....||.|#.|...|#.",
    "...|#..||....|#..|....|...|.||#..||..#.|..##......"
]

var matrix = puzzle
var next = matrix
var height = matrix.count
var width = matrix[0].count

enum Direction: Int {
    case up = 0
    case left = 1
    case right = 2
    case down = 3
}

struct Point: Comparable {
    var x: Int
    var y: Int
    
    func moveOne(_ dir: Direction) -> Point {
        switch dir {
        case .up: return up
        case .down: return down
        case .left: return left
        case .right: return right
        }
    }
    
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
    var up_left: Point {
        return Point(x: x-1, y: y-1)
    }
    var up_right: Point {
        return Point(x: x+1, y: y-1)
    }
    var down_left: Point {
        return Point(x: x-1, y: y+1)
    }
    var down_right: Point {
        return Point(x: x+1, y: y+1)
    }
    var isValid: Bool {
        return x >= 0 && y >= 0 && x < width && y < height
    }
    
    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
}


var water = [Point]()

func printMatrix() {
    for l in matrix {
        print(l)
    }
    print("")
}

func getPoint(_ p: Point) -> Character {
    let line = matrix[p.y]
    return line[line.index(line.startIndex, offsetBy: p.x)]
}

func setPoint(_ p: Point, c: Character) {
    let line = next[p.y]
    let start = line.index(line.startIndex, offsetBy: p.x)
    let end = line.index(line.startIndex, offsetBy: p.x+1)
    next[p.y] = line.replacingCharacters(in: start..<end, with: "\(c)")
}

func countTreeLumber(p: Point) -> (tree: Int, lumber: Int) {
    var trees = 0
    var lumber = 0
    
    for ps in [p.up, p.down, p.left, p.right, p.down_left, p.down_right, p.up_left, p.up_right] {
        if ps.isValid {
            if getPoint(ps) == "#" {
                lumber = lumber + 1
            }
            else if getPoint(ps) == "|" {
                trees = trees + 1
            }
        }
    }
    // print("\(p), \(trees), \(lumber)")
    return (tree: trees, lumber: lumber)
}

func nextStep() {
    for y in 0..<matrix.count {
        for x in 0..<matrix[y].count {
            let p = Point(x: x, y: y)
            let (trees, lumber) = countTreeLumber(p: p)
            if getPoint(p) == "." && trees >= 3 {
                setPoint(p, c: "|")
            }
            if getPoint(p) == "|" && lumber >= 3 {
                setPoint(p, c: "#")
            }
            if getPoint(p) == "#" {
                if lumber >= 1 && trees >= 1 {
                    setPoint(p, c: "#")
                }
                else {
                    setPoint(p, c: ".")
                }
            }
        }
    }
}

func printCount() {
    var tr = 0
    var lu = 0
    
    for y in 0..<height {
        for x in 0..<width {
            let p = getPoint(Point(x: x, y: y))
            if p == "#" {
                lu = lu + 1
            }
            if p == "|" {
                tr = tr + 1
            }
        }
    }
    
    print("TREE: \(tr), LUMBER: \(lu)")
}

printMatrix()

var min = 1
while min < 10000 {
    nextStep()
    matrix = next
    // printMatrix()
    printCount()
    print("AFTER STEP \(min)")
    min = min + 1
}

printCount()


