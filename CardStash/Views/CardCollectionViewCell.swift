//
//  CardCollectionViewCell.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import Foundation
import UIKit
import Nuke

class CardCollectionViewCell: UICollectionViewCell {
    
    private let viewModel = ViewModel()
    
    // MARK: IBOutlets
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var set: UILabel!
    @IBOutlet weak var HP: UILabel!
    @IBOutlet weak var heart: UIImageView!
    @IBOutlet weak var ownedLabel: UILabel!
    
    static let reuseIdentifier = "cardCell"
    
    func configure(index: Int) {
        name.text = viewModel.getCardName(index: index)
        HP.text = viewModel.getCardHP(index: index)
        set.text = viewModel.getCardSet(index: index)
        cardImage.image = UIImage(named: "cardplaceholder")
        heart.isHidden = viewModel.showHideHeart(index: index)
        ownedLabel.isHidden = viewModel.showOwned(index: index)
        ownedLabel.text = viewModel.getOwnedQuantity(index: index)
        ownedLabel.layer.masksToBounds = true
        ownedLabel.layer.cornerRadius = 12
        
        DispatchQueue.main.async {
            if let url = self.viewModel.getImageURL(index: index) {
                let request = ImageRequest(url: url, processors: [ImageProcessors.Resize(size: CGSize(width: self.frame.width, height: self.frame.height), contentMode: ImageProcessors.Resize.ContentMode.aspectFill)])
                
                Nuke.loadImage(with: request, options: NukeOptions.options, into: self.cardImage) { response, completed, total in
                    if response != nil {
                        self.cardImage.image = response?.image
                    } else {
                        self.cardImage.image = NukeOptions.options.failureImage
                    }
                }
            }
        }
    }
}
