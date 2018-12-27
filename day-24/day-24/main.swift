//
//  main.swift
//  day-24
//
//  Created by Vladimir Svidersky on 12/23/18.
//  Copyright © 2018 Vladimir Svidersky. All rights reserved.
//

import Foundation

var attackRegistry: [String: String] = [String: String]()

extension Group: Comparable {

    var effectivePower: Int {
        return units * power
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    static func < (lhs: Group, rhs: Group) -> Bool {
        return lhs.effectivePower > rhs.effectivePower || (lhs.effectivePower == rhs.effectivePower && lhs.order < rhs.order)
    }

    func damageTo(_ enemy: Group) -> Int {
        let actual = effectivePower
        if enemy.immuneTo.contains(attack) {
            return 0
        }
        else if enemy.weakTo.contains(attack) {
            return actual * 2
        }
//        else if enemy.hits > actual {
//            actual = 0
//        }
        
        return actual
    }
    
    func findTarget() -> String? {
        var mostDamage = -1
        var result: Group?
        
        let potentialTargets = groups.filter{ $0.type != type && attackRegistry.values.contains($0.id) == false }.sorted()
        print("Potential targets for \(id):")
        for j in potentialTargets {
            j.printDescription()
        }
        
        for enemy in potentialTargets {
            let damage = damageTo(enemy)
            print("\(id) would do \(damage) to \(enemy.id)")

            if damage == 0 {
                continue
            }
            
            if damage > mostDamage {
                print("This is the best so far")
                mostDamage = damage
                result = enemy
            } else if (damage == mostDamage && enemy < result!) {
                print("ERROR: Should not see this. Potential targets should be sorted already!")
                abort()
            }
        }
        
        if result != nil {
            print("\(id) will try to attack \(result!.id)")
        }
        else {
            print("\(id) will stand...")
        }
        
        return result?.id
    }
    
    func doAttack(_ enemyId: String?) -> Int {
        guard enemyId != nil else {
            print("\(id) has nobody to attack")
            return 0
        }
        guard units > 0 else {
            print("\(id) is already dead and has no units to attack (\(units))")
            return 0
        }
        
        let enemy = groups.first(where: { $0.id == enemyId })!
        if enemy.units <= 0 {
            print("Should not see this. We are attacking the dead group")
            abort()
        }
        
        let damage = damageTo(enemy)
        let killed = damage / enemy.life
        enemy.units = enemy.units - killed
        
        print("\(id) is attacking \(enemy.id). Kills \(killed) units. Remaining \(enemy.units)")

        // Tests
        assert(killed * enemy.life <= damage)
        assert((killed+1) * enemy.life > damage)

        return enemy.units > 0 ? killed : killed + enemy.units
    }
    
    func printDescription() {
        print("\(id), \(units) @ \(life) ⚔︎ \(power) \(attack). EP: \(effectivePower) #\(order) Weak: [\(weakToString)], Immune: [\(immuneToString)]")
    }
}

func printGroups(_ grs: [Group]) {
    for group in grs {
        group.printDescription()
    }
}

// Single combat step
func doStep() -> Int {
    groups = groups.sorted()
    
    print("\n*** TARGET SELECTION:")
    printGroups(groups)

    attackRegistry.removeAll()
    for g in groups {
        if let target = g.findTarget() {
            attackRegistry[g.id] = target
        }
    }
    
    var totalKill = 0
    print("\n*** ATTACK:")
    for g in groups.sorted(by: { $0.order > $1.order }) {
        totalKill = totalKill + g.doAttack(attackRegistry[g.id])
    }
    groups = groups.filter({ $0.units > 0 })
    return totalKill
}

while boost >= minBoost {
    
    initialize()

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
