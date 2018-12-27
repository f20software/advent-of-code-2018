//
//  input.swift
//  day-24
//
//  Created by Vladimir Svidersky on 12/23/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

// Will run from boost to minBoost
var boost = 88
let minBoost = 88

enum AttackType: String {
    case radiation
    case bludgeoning
    case fire
    case slashing
    case cold
}

enum GroupType {
    case infection
    case immune
}

class Group {
    var type: GroupType
    var id: String
    var units: Int
    var life: Int
    var attack: AttackType
    var power: Int
    var order: Int
    var weakTo: Set<AttackType>
    var weakToString: String
    var immuneTo: Set<AttackType>
    var immuneToString: String
    
    init(type: GroupType, id: String, units: Int, hits: Int,
         attack: AttackType, power: Int, order: Int,
         weakTo: Set<AttackType>, immuneTo: Set<AttackType>)
    {
        self.type = type
        self.id = id
        self.units = units
        self.life = hits
        self.attack = attack
        self.power = power + (type == .immune ? boost : 0)
        self.order = order
        self.weakTo = weakTo
        self.weakToString = self.weakTo.map({ $0.rawValue }).joined(separator: ", ")
        self.immuneTo = immuneTo
        self.immuneToString = self.immuneTo.map({ $0.rawValue }).joined(separator: ", ")
    }
}

var groups: [Group] = [Group]()

func initialize() {
    
    // Test data
//    groups = [
//        Group(type: .immune, id: "M1", units: 17, hits: 5390, attack: .fire, power: 4507, order: 2,
//              weakTo: [.radiation, .bludgeoning], immuneTo: []),
//
//        Group(type: .immune, id: "M2", units: 989, hits: 1274, attack: .slashing, power: 25, order: 3,
//              weakTo: [.bludgeoning, .slashing], immuneTo: [.fire]),
//
//        Group(type: .infection, id: "F1", units: 801, hits: 4706, attack: .bludgeoning, power: 116, order: 1,
//              weakTo: [.radiation], immuneTo: []),
//
//        Group(type: .infection, id: "F2", units: 4485, hits: 2961, attack: .slashing, power: 12, order: 4,
//              weakTo: [.fire, .cold], immuneTo: [.radiation])
//    ]
    
    // Puzzle data
    groups = [
        Group(type: .immune, id: "M1", units: 4400, hits: 10384, attack: .radiation, power: 21, order: 16,
              weakTo: [.slashing], immuneTo: []),
        Group(type: .immune, id: "M2", units: 974, hits: 9326, attack: .cold, power: 86, order: 19,
              weakTo: [.radiation], immuneTo: []),
        Group(type: .immune, id: "M3", units: 543, hits: 2286, attack: .cold, power: 34, order: 13,
              weakTo: [], immuneTo: []),
        Group(type: .immune, id: "M4", units: 47, hits: 4241, attack: .cold, power: 889, order: 10,
              weakTo: [.slashing, .cold], immuneTo: [.radiation]),
        Group(type: .immune, id: "M5", units: 5986, hits: 4431, attack: .cold, power: 6, order: 8,
              weakTo: [], immuneTo: []),
        Group(type: .immune, id: "M6", units: 688, hits: 1749, attack: .cold, power: 23, order: 7,
              weakTo: [], immuneTo: [.slashing, .radiation]),
        Group(type: .immune, id: "M7", units: 61, hits: 1477, attack: .fire, power: 235, order: 1,
              weakTo: [], immuneTo: []),
        Group(type: .immune, id: "M8", units: 505, hits: 9333, attack: .radiation, power: 174, order: 9,
              weakTo: [.slashing, .cold], immuneTo: []),
        Group(type: .immune, id: "M9", units: 3745, hits: 8367, attack: .bludgeoning, power: 21, order: 3,
              weakTo: [.cold], immuneTo: [.fire, .slashing, .radiation]),
        Group(type: .immune, id: "M10", units: 111, hits: 3482, attack: .cold, power: 331, order: 15,
              weakTo: [], immuneTo: []),
        
        Group(type: .infection, id: "F1", units: 2891, hits: 32406, attack: .slashing, power: 22, order: 2,
              weakTo: [.fire, .bludgeoning], immuneTo: []),
        Group(type: .infection, id: "F2", units: 1698, hits: 32906, attack: .fire, power: 27, order: 17,
              weakTo: [.radiation], immuneTo: []),
        Group(type: .infection, id: "F3", units: 395, hits: 37715, attack: .cold, power: 183, order: 6,
              weakTo: [], immuneTo: [.fire]),
        Group(type: .infection, id: "F4", units: 3560, hits: 45025, attack: .cold, power: 20, order: 14,
              weakTo: [.radiation], immuneTo: [.fire]),
        Group(type: .infection, id: "F5", units: 2335, hits: 15938, attack: .slashing, power: 13, order: 11,
              weakTo: [.cold], immuneTo: []),
        Group(type: .infection, id: "F6", units: 992, hits: 19604, attack: .radiation, power: 38, order: 5,
              weakTo: [], immuneTo: [.slashing, .bludgeoning, .radiation]),
        Group(type: .infection, id: "F7", units: 5159, hits: 44419, attack: .bludgeoning, power: 13, order: 4,
              weakTo: [.fire], immuneTo: [.slashing]),
        Group(type: .infection, id: "F8", units: 2950, hits: 6764, attack: .radiation, power: 4, order: 18,
              weakTo: [.slashing], immuneTo: []),
        Group(type: .infection, id: "F9", units: 6131, hits: 25384, attack: .cold, power: 7, order: 12,
              weakTo: [.slashing], immuneTo: [.bludgeoning, .cold]),
        Group(type: .infection, id: "F10", units: 94, hits: 29265, attack: .bludgeoning, power: 588, order: 20,
              weakTo: [.cold, .bludgeoning], immuneTo: [])
    ]
}
