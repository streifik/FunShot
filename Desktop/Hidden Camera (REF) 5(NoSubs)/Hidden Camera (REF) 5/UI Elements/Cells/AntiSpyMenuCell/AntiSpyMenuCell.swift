//
//  AntiSpyMenuCell.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import UIKit

class AntiSpyMenuCell: UITableViewCell {
    @IBOutlet var labels: [UILabel]!
    
    var completion: ((AntiSpyViewController.Action_anti_spy) -> Void)?
    
    @IBAction func cameraObscuraTapped(_ sender: UIButton) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.cameraObscura) }
    @IBAction func infraredCameraTapped(_ sender: UIButton) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.infraredCamera)
    }
    @IBAction func wirelessObscura(_ sender: UIButton) { 
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.wiredObscure) }
    @IBAction func wiredObscuraTapped(_ sender: UIButton) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.wiredObscure) }
    @IBAction func sleepCamera(_ sender: UIButton) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.sleepCamera)
    }
    @IBAction func otherTapped(_ sender: UIButton) {
        func somDogAndwhaterver(game: NSNumber, treg: Bool, completion: () -> Void) -> Bool {
            var a = (game as! Decimal) + 300 + 30
            a += 95
            return treg == true || a == 30
        }
        completion?(.other)
    }
}
