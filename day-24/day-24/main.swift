//
//  main.swift
//  day-24
//
//  Created by Vladimir Svidersky on 12/23/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

enum AttackType {
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

var groups = puzzle
var attackRegistry: [String: String] = [String: String]()

extension Group {

    func damageTo(_ enemy: Group) -> Int {
        var actual = effectivePower
        if enemy.immuneTo.contains(attack) {
            actual = 0
        }
        else if enemy.weakTo.contains(attack) {
            actual = actual * 2
        }
        
        return actual
    }
    
    func findTarget() -> String? {
        var mostDamage = -1
        var result: Group?
        
        let pts = groups.filter{ $0.type != type }.sorted()
        for i in 0..<pts.count {
            // If somebody else is attacking this group - skip
            if attackRegistry.values.contains(pts[i].id) {
                continue
            }
            
            let damage = damageTo(pts[i])
            if damage == 0 {
                continue
            }
            
            // print("\(id) would do \(damage) to \(pts[i].id)")
            
            if damage > mostDamage ||
                (damage == mostDamage && result!.effectivePower < pts[i].effectivePower) ||
                (damage == mostDamage && result!.effectivePower == pts[i].effectivePower && result!.order > pts[i].order) {
                // print("This is the best so far")
                mostDamage = damage
                result = pts[i]
            }
        }
        
        //print("\(id) would try to attack \(result?.id)")
        return result?.id
    }
    
    func doAttack(_ enemyId: String?) -> Int {
        guard enemyId != nil else {
            print("\(id) has nobody to attack")
            return 0
        }
        guard units > 0 else {
            print("\(id) has no units (\(units) to attack")
            return 0
        }
        
        let g = groups.first(where: { $0.id == enemyId })!
        if g.units < 0 {
            print("Should not see this. We are attacking the dead group")
            abort()
        }
        let damage = damageTo(g)
        let killed = damage / g.hits
        g.units = g.units - killed
        print("\(id) is attacking \(g.id). Kills \(killed) units. Remaining \(g.units)")
        return g.units > 0 ? killed : killed + g.units
    }
    
    func printDescription() {
        print("\(id), \(units) @ \(hits). Effective Power: \(effectivePower) \(order)")
    }
}

func printGroups() {
    for g in groups {
        g.printDescription()
    }
}

func doStep() -> Int {
    groups = groups.sorted()

    attackRegistry.removeAll()
    for g in groups {
        if let target = g.findTarget() {
            attackRegistry[g.id] = target
        }
    }
    print(attackRegistry)
    
    var totalKill = 0
    for g in groups.sorted(by: { $0.order > $1.order }) {
        totalKill = totalKill + g.doAttack(attackRegistry[g.id])
    }
    groups = groups.filter({ $0.units > 0 })

    printGroups()
    print()
    
    return totalKill
}

// Start
func initialize() {
    
    puzzle = [
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


while boost > 0 {
    
    initialize()
    groups = puzzle.sorted()
    printGroups()

    var mcount = 1
    var fcount = 1
    var totalKilled = 1

    while mcount > 0 && fcount > 0 && totalKilled > 0 {
        totalKilled = doStep()
        mcount = groups.filter({ $0.type == .immune }).count
        fcount = groups.filter({ $0.type == .infection }).count
    }

    if totalKilled == 0 {
        print("BOOST \(boost). RESULT - TIE")
    }
    else {
        print("BOOST \(boost). RESULT - \(mcount) \(fcount) \(groups.map({ $0.units }).reduce(0, +))")
    }

    boost = boost - 1
}
