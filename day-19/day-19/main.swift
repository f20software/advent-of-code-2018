//
//  main.swift
//  day-19
//
//  Created by Vladimir Svidersky on 12/18/18.
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
        var match = cmd.matchingStrings(regex: "([a-z]{4}) ([0-9]{1,2}) ([0-9]{1,2}) ([0-9]{1,2})")
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
}

var regs = [1, 0, 0, 0, 0, 0]

func executeOperation(cmd: Command) {
    
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
    // print("\(regs)")
}

let dump = puzzle
let ip_reg = 3

var decodedCommands = [String: Command]()

var steps = 0
while (true) {
    let ip = regs[ip_reg]
    if ip < 0 || ip >= dump.count {
        print("THE END. \(regs)")
        abort()
    }
    
    let line = dump[ip]
    var cmd = decodedCommands[line]
    if cmd == nil {
        cmd = Command(line)
        decodedCommands[line] = cmd
    }

    let r0 = regs[0]
    
    executeOperation(cmd: cmd!)
    regs[ip_reg] = regs[ip_reg] + 1
    
    if regs[0] != r0 {
        print("\(steps): \(regs)")
    }
    
    steps = steps + 1
}

//print(10551354+5275677+3517118+1758559+959214+479607+319738+159869+66+33+22+11+6+3+2+1)
//decompose(num: 10551354)
//exit(0)
func decompose(num: Int) {
    var i = 2
    var rem = num
    
    while rem > 0 {
        if (rem % i) == 0 {
            print(i)
            rem = rem / i
            // i = i + 1
        }
        else {
            i = i + 1
        }
    }
}





