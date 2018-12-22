//
//  input.swift
//  day-21
//
//  Created by Vladimir Svidersky on 12/20/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

let puzzle = [
    "seti 123 0 5",         // 0: 123 -> r5
    "bani 5 456 5",         // 1: r5 = r5 & 456
    "eqri 5 72 5",          // 2: if r5 == 72
    "addr 5 2 2",           // 3: then goto line 5
    "seti 0 0 2",           // 4: else goto line 1
    "seti 0 3 5",           // 5: r5 = 0
    "bori 5 65536 3",       // 6: r3 = r5 | 0x10000 (0x10000)
    "seti 9010242 6 5",     // 7: r5 = 9010242
    "bani 3 255 1",         // 8: r1 = r3 | 0xFF (0x100FF)
    "addr 5 1 5",           // 9: r5 = r5 + r1
    "bani 5 16777215 5",    // 10: r5 = r5 & 0xFFFFFF (leave lower 6 hex-digits)
    "muli 5 65899 5",       // 11: r5 = r5 * 65899
    "bani 5 16777215 5",    // 12: r5 = r5 & 0xFFFFFF (leave lower 6 hex-digits)
    "gtir 256 3 1",         // 13: r1 = 256 > r3 ? 1 : 0 (1)
    "addr 1 2 2",           // 14: r2 = r2 + r1
    "addi 2 1 2",           // 15: r2 = r2 + 1
    "seti 27 6 2",          // 16: goto line 28
    "seti 0 8 1",           // 17: r1 = 0
    "addi 1 1 4",           // 18: r4 = r1 + 1
    "muli 4 256 4",         // 19: r4 = r4 * 256
    "gtrr 4 3 4",           // 20: if r4 > r3 then {
    "addr 4 2 2",           // 21:    goto line 26
    "addi 2 1 2",           // 22: } else {
    "seti 25 5 2",          // 23:    r1 = r1 + 1
    "addi 1 1 1",           // 24:    goto line 18
    "seti 17 7 2",          // 25: }
    "setr 1 3 3",           // 26: r3 = r1
    "seti 7 2 2",           // 27: goto line 8
    "eqrr 5 0 1",           // 28: if r0 == r5
    "addr 1 2 2",           // 29: then abort()
    "seti 5 2 2"            // 30: else goto line 6
]
