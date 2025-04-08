//
//  DeckCollectionViewCell.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 4/8/25.
//

import Foundation
import UIKit
import Nuke

class DeckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var deckName: UILabel!
    @IBOutlet weak var cardImage1: UIImageView!
    @IBOutlet weak var cardImage2: UIImageView!
    @IBOutlet weak var cardImage3: UIImageView!
    @IBOutlet weak var cardImage4: UIImageView!
    
    static let reuseIdentifier = "deckCell"
}
