//
//  main.swift
//  day-21
//
//  Created by Vladimir Svidersky on 12/20/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

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

class Command {
    var op: String
    var a: Int
    var b: Int
    var c: Int
    
    init(_ cmd: String) {
        var match = cmd.matchingStrings(regex: "([a-z]{4}) ([0-9]{1,8}) ([0-9]{1,8}) ([0-9]{1,8})")
        if match.count > 0 {
            self.op = match[0][1]
            self.a = Int(match[0][2])!
            self.b = Int(match[0][3])!
            self.c = Int(match[0][4])!
        }
        else {
            abort()
        }
    }
    
    var description: String {
        return "\(op) \(a) \(b) \(c)"
    }
}

var regs = [0, 0, 0, 0, 0, 0]
var program = [Command]()

func executeOperation(line: Int, cmd: Command) {
    
    switch cmd.op {
    case "addr":
        regs[cmd.c] = regs[cmd.a] + regs[cmd.b]
    case "addi":
        regs[cmd.c] = regs[cmd.a] + cmd.b
    case "mulr":
        regs[cmd.c] = regs[cmd.a] * regs[cmd.b]
    case "muli":
        regs[cmd.c] = regs[cmd.a] * cmd.b
    case "banr":
        regs[cmd.c] = regs[cmd.a] & regs[cmd.b]
    case "bani":
        regs[cmd.c] = regs[cmd.a] & cmd.b
    case "borr":
        regs[cmd.c] = regs[cmd.a] | regs[cmd.b]
    case "bori":
        regs[cmd.c] = regs[cmd.a] | cmd.b
    case "setr":
        regs[cmd.c] = regs[cmd.a]
    case "seti":
        regs[cmd.c] = cmd.a
    case "gtir":
        regs[cmd.c] = cmd.a > regs[cmd.b] ? 1 : 0
    case "gtri":
        regs[cmd.c] = regs[cmd.a] > cmd.b ? 1 : 0
    case "gtrr":
        regs[cmd.c] = regs[cmd.a] > regs[cmd.b] ? 1 : 0
    case "eqir":
        regs[cmd.c] = cmd.a == regs[cmd.b] ? 1 : 0
    case "eqri":
        regs[cmd.c] = regs[cmd.a] == cmd.b ? 1 : 0
    case "eqrr":
        regs[cmd.c] = regs[cmd.a] == regs[cmd.b] ? 1 : 0
        
    default:
        print("UNKNOWN COMMAND \(cmd.op).")
        abort()
        break
    }
    
    // print("\(line): \(cmd.description) \(regs) \(cmd.c == 2 ? "*) reg2 updated" : "")")
}

let ip_reg = 2
// Print registers after chk_reg value is changed - good way to see program execution progress
let chk_reg = 5
// Step counter
var steps = 0

func prepareProgram() {
    for line in puzzle {
        program.append(Command(line))
    }
}

func executeProgram1() {
    var cmd = program[0]
    
    while (cmd.op != "eqrr") {
        let ip = regs[ip_reg]
        if ip < 0 || ip >= program.count {
            return
        }

        let rchk = regs[chk_reg]
        cmd = program[ip]
        
        executeOperation(line: ip, cmd: cmd)
        regs[ip_reg] = regs[ip_reg] + 1
        
        if regs[chk_reg] != rchk {
            print("\(steps): \(regs)")
        }
        
        steps = steps + 1
    }
}

func executeProgram2() {
    var cmd = program[0]
    var matchedNumbers: [Int: Bool] = [Int: Bool]()
    
    while (true) {
        let ip = regs[ip_reg]
        if ip < 0 || ip >= program.count {
            return
        }
        
        cmd = program[ip]
        
        executeOperation(line: ip, cmd: cmd)
        regs[ip_reg] = regs[ip_reg] + 1
        
        if cmd.op == "eqrr" {
            if matchedNumbers[regs[5]] != nil {
                print("Found first duplicated number in reg5")
                break
            }
            matchedNumbers[regs[5]] = true
            print("\(matchedNumbers.count): \(regs[5])")
        }
        
        steps = steps + 1
    }
}

prepareProgram()

// Part 1
executeProgram1()
print("\(steps): \(regs)")
print("Putting \(regs[5]) in reg0 would make the program stop as soon as possible.")

// Part 2
executeProgram2()



