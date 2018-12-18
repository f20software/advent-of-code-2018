//
//  main.swift
//  day-15
//
//  Created by Vladimir Svidersky on 12/14/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

let input_final = [
    "################################",
    "#################..#############",
    "##########..###G..##############",
    "#######...G..#G..#...###..######",
    "#######....###......###...######",
    "#####G..G..###........#...G..###",
    "#####G......##.....G....G....###",
    "###....G....###..............#.#",
    "###.G........#.G...............#",
    "###............G............#..#",
    "###G.....G##..................##",
    "###.......#.E...G...........####",
    "##..........G.#####............#",
    "#####........#######...E...E...#",
    "#####.E.....#########.....#.#.##",
    "##.#...G....#########.###.#.#.##",
    "#...........#########.##########",
    "###......G..#########.##########",
    "##..........#########.##########",
    "#....##.G....#######.....#######",
    "###E.##....E..#####..E....######",
    "#######.#................#######",
    "########......#E.....###########",
    "#########......E.....###########",
    "##########.........E############",
    "##########.........#############",
    "##########..###..###############",
    "##########..###..###############",
    "###########..###...#############",
    "##########...#####....##########",
    "###########..########...########",
    "################################"
]

// 76*2857 is not correct
// 76*2872 218272

// GOOD
let input0 = [
"#######",
"#.G...#",
"#...EG#",
"#.#.#G#",
"#..G#E#",
"#.....#",
"#######"]

// 37, 982
let input1 = [
"#######",
"#G..#E#",
"#E#E.E#",
"#G.##.#",
"#...#E#",
"#...E.#",
"#######"]

// 46, 859
let input2 = [
"#######",
"#E..EG#",
"#.#G.E#",
"#E.##E#",
"#G..#.#",
"#..E#.#",
"#######"]

// 35, 793
let input3 = [
"#######",
"#E.G#.#",
"#.#G..#",
"#G.#.G#",
"#G..#.#",
"#...E.#",
"#######"]

// 20, 937
let input4 = [
"#########",
"#G......#",
"#.E.#...#",
"#..##..G#",
"#...##..#",
"#...#...#",
"#.G...G.#",
"#.....G.#",
"#########"]

// 54, 536
let input5 = [
"#######",
"#.E...#",
"#.#..G#",
"#.###.#",
"#E#G#G#",
"#...#G#",
"#######"]

var d = input_final

enum BodyType {
    case goblin
    case elf
}

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

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    static func < (lhs: Point, rhs: Point) -> Bool {
        return lhs.y < rhs.y || (lhs.y == rhs.y && lhs.x < rhs.x)
    }
}

class Destination: Comparable {
    var p: Point
    var reachable: Bool = false
    var distance: Int = cantReach
    var direction: Direction = .up
    
    init(_ p: Point) {
        self.p = p
    }

    static func == (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.distance == rhs.distance && lhs.direction == rhs.direction
    }

    static func < (lhs: Destination, rhs: Destination) -> Bool {
        return lhs.distance < rhs.distance || (lhs.distance == rhs.distance && lhs.direction.rawValue < rhs.direction.rawValue)
    }
}

func getPoint(_ p: Point) -> Character {
    let line = d[p.y]
    return line[line.index(line.startIndex, offsetBy: p.x)]
}

func isEmpty(_ p: Point) -> Bool {
    return getPoint(p) == "."
}

func setPoint(_ p: Point, c: Character) {
    let line = d[p.y]
    let start = line.index(line.startIndex, offsetBy: p.x)
    let end = line.index(line.startIndex, offsetBy: p.x+1)
    d[p.y] = line.replacingCharacters(in: start..<end, with: "\(c)")
}

let cantReach = 100000

func isReachable(from: Point, to: Point) -> (reach: Bool, distance: Int, first: Direction) {
    // Build number clone
    var n = [[Int]]()
    for y in 0..<d.count {
        var line = [Int]()
        for x in 0..<d[y].count {
            
            let xy = Point(x: x, y: y)
            if (xy == to) {
                line.append(0)
                continue
            }
            else if (xy == from) {
                line.append(-1)
                continue
            }

            if isEmpty(xy) {
                line.append(-1)
            }
            else {
            // case "#", "E", "G":
                line.append(-100)
            }
        }
        n.append(line)
    }
    
    var step = 1
    var didSomething = false

    repeat {
        didSomething = false
        
        for y in 0..<n.count {
            for x in 0..<n[y].count {
                if n[y][x] == (step - 1) {
                    if n[y-1][x] == -1 {
                        n[y-1][x] = step
                        didSomething = true
                    }
                    if n[y+1][x] == -1 {
                        n[y+1][x] = step
                        didSomething = true
                    }
                    if n[y][x+1] == -1 {
                        n[y][x+1] = step
                        didSomething = true
                    }
                    if n[y][x-1] == -1 {
                        n[y][x-1] = step
                        didSomething = true
                    }
                }
            }
        }
        
        if n[from.y][from.x] == step {
            // We got it...
            var dir: Direction?
            if n[from.y-1][from.x] == step-1 {
                dir = .up
            }
            else if n[from.y][from.x-1] == step-1 {
                dir = .left
            }
            else if n[from.y][from.x+1] == step-1 {
                dir = .right
            }
            else if n[from.y+1][from.x] == step-1 {
                dir = .down
            }

            //print("point1: \(p1.x),\(p1.y), point2: \(p2.x),\(p2.y), \(true), \(step), \(dir!)")
            return (reach: true, distance: step, first: dir!)
        }
        
        step = step + 1
    }
    while didSomething == true
    
    //print("point1: \(p1.x),\(p1.y), point2: \(p2.x),\(p2.y), \(false)")
    return (reach: false, distance: cantReach, first: Direction.up)
}


var goblins: Int = 0
var elfs: Int = 0

class Unit {
    let type: BodyType
    let char: Character
    var life: Int = 200
    var power: Int = 3
    var p: Point
    
    init(type: BodyType, p: Point) {
        self.type = type
        self.char = (type == .elf ? "E" : "G")
        self.p = p
        if type == .elf {
            self.power = 25
        }
    }

    var descr: String {
        return "\(char)-\(life) @ \(p.x),\(p.y)"
    }
    
    func gotHitBy(_ who: Unit) {
        if life <= 0 {
            print("ERROR: I'm already dead!!!!")
            return
        }
    
        print("\(who.descr) -> \(descr) ... \(life-who.power)")
    
        life = life - who.power
        if life <= 0 {
            setPoint(p, c: ".")
            if type == .elf {
                elfs = elfs - 1
                print("Elf has died... ABORT!!!")
                abort()
            }
            else {
                goblins = goblins - 1
            }
            units = units.filter { $0.life > 0 }
        }
    }
    
    func nextMove() -> Direction? {
        let targets = units.filter { $0.type != type }
        var nps = [Destination]()
        
        for t in targets {
            for p in [t.p.up, t.p.left, t.p.right, t.p.down] {
                if isEmpty(p) {
                    nps.append(Destination(p))
                }
            }
        }

        if nps.count == 0 {
            // No potential targets
            return nil
        }
        
        for i in 0..<nps.count {
            let (reach, distance, direction) = isReachable(from: p, to: nps[i].p)
            nps[i].reachable = reach
            nps[i].distance = distance
            nps[i].direction = direction
        }
        
        nps = nps.filter { $0.reachable == true }
        
        if nps.count == 0 {
            return nil
        }

        nps = nps.sorted(by: { (a, b) -> Bool in
            return (a.distance < b.distance) ||
                (a.distance == b.distance && a.p < b.p)
        })

        return nps[0].direction
    }
    
    func gotEnemy() -> Bool {
        return units.filter({ $0.type != type }).count > 0
    }
    
    func attack() -> Bool {

        let pts = units.filter({ $0.type != self.type && (
            $0.p == self.p.up || $0.p == self.p.down || $0.p == self.p.left || $0.p == self.p.right )})
        
        if pts.count == 0 {
            return false
        }

        var lifes = pts.map({ $0.life }).sorted()
        let minLife = lifes[0]
        
        if let target = units.first(where: { $0.p == self.p.up && $0.type != self.type && $0.life == minLife }) {
            target.gotHitBy(self)
            return true
        }
        if let target = units.first(where: { $0.p == self.p.left && $0.type != self.type && $0.life == minLife }) {
            target.gotHitBy(self)
            return true
        }
        if let target = units.first(where: { $0.p == self.p.right && $0.type != self.type && $0.life == minLife }) {
            target.gotHitBy(self)
            return true
        }
        if let target = units.first(where: { $0.p == self.p.down && $0.type != self.type && $0.life == minLife }) {
            target.gotHitBy(self)
            return true
        }

        
        return false
    }
    
    func move() -> Bool {
        
        if (gotEnemy() == false) {
            return false
        }
        
        
        if life <= 0 {
            print("ERROR! I'm dead and should not move")
            return true
        }
        
        if attack() {
            return true
        }

        if let dir = nextMove() {
            // print("\(descr) moves \(dir)")
            let np = p.moveOne(dir)
            setPoint(p, c: ".")
            setPoint(np, c: char)
            p = np
        }
            
        _ = attack()
        return true
    }
}

var units = [Unit]()

func getBodies() {
    for y in 0..<d.count {
        for x in 0..<d[y].count {
            let p = Point(x: x, y: y)
            let c = getPoint(p)
            if c == "G" {
                units.append(Unit(type: .goblin, p: p))
                goblins = goblins + 1
            }
            else if c == "E" {
                units.append(Unit(type: .elf, p: p))
                elfs = elfs + 1
            }
        }
    }
}

func sortBodies() {
    units = units.sorted(by: { $0.p < $1.p })
}

func moveBodies() -> Bool {
    for u in units {
        if u.move() == false {
            return false
        }
    }
    
    return true
}


func printState() {
    for y in 0..<d.count {
        var line = d[y]
        line.append(" ")
        for u in units {
            if u.p.y == y {
                line.append("\(u.char)(\(u.life)) ")
            }
        }
        print(line)
    }
}

getBodies()
printState()
print()
var movesComplete = 0

while elfs > 0 && goblins > 0 {
    sortBodies()
    let complete = moveBodies()
    printState()
    let totalGLife = units.filter{ $0.type == .goblin }.map{ $0.life }.reduce(0, +)
    let totalELife = units.filter{ $0.type == .elf }.map{ $0.life }.reduce(0, +)

    if complete {
        movesComplete = movesComplete + 1
        print("MOVE \(movesComplete) END. Gs: \(totalGLife) Es: \(totalELife)")
    }
    else {
        
    }
    print()
}

let totalLife = units.map{ $0.life }.reduce(0, +)
print("THE END. \(movesComplete), \(totalLife)")


