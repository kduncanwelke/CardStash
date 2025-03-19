//
//  CardDetailViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/28/25.
//

import Foundation
import UIKit
import Nuke

class CardDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var cardSet: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var stage: UILabel!
    @IBOutlet weak var rarity: UILabel!
    @IBOutlet weak var weakness: UILabel!
    @IBOutlet weak var resistance: UILabel!
    @IBOutlet weak var retreatCost: UILabel!
    @IBOutlet weak var flavorText: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var ownedLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()
    weak var updateCellDelegate: UpdateCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepper.layer.cornerRadius = 5
        stepper.addTarget(self, action: #selector(stepperChanged(stepper:)), for: .valueChanged)
        loadCard()
    }
    
    // MARK: Custom functions
    
    func loadCard() {
        name.text = viewModel.getCardName(index: viewModel.getSelected())
        number.text = viewModel.getCardNumber(index: viewModel.getSelected())
        cardSet.text = "Card Set: \(viewModel.getCardSet(index: viewModel.getSelected()))"
        hp.text = viewModel.getCardHP(index: viewModel.getSelected())
        type.text = viewModel.getCardType(index: viewModel.getSelected())
        stage.text = viewModel.getCardStage(index: viewModel.getSelected())
        weakness.text = viewModel.getCardWeakness(index: viewModel.getSelected())
        resistance.text = viewModel.getCardResistance(index: viewModel.getSelected())
        retreatCost.text = viewModel.getCardRetreatCost(index: viewModel.getSelected())
        flavorText.text = viewModel.getCardFlavorText(index: viewModel.getSelected())
        favoriteButton.setTitle(viewModel.getHeartTitle(index: viewModel.getSelected()), for: .normal)
        favoriteButton.setImage(viewModel.getHeartForCard(index: viewModel.getSelected()), for: .normal)
        ownedLabel.text = viewModel.getOwnedQuantity(index: viewModel.getSelected())
        stepper.value = Double(viewModel.getOwnedNumber(index: viewModel.getSelected()))
        rarity.text = viewModel.getCardRarity(index: viewModel.getSelected())
        
        DispatchQueue.main.async {
            if let url = self.viewModel.getImageURL(index: self.viewModel.getSelected()) {
                let request = ImageRequest(url: url, processors: [ImageProcessors.Resize(size: CGSize(width: self.cardImage.frame.width, height: self.cardImage.frame.height), contentMode: ImageProcessors.Resize.ContentMode.aspectFill)])
                
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
    
    // MARK: IBActions
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        viewModel.isFavorite()
        
        favoriteButton.setTitle(viewModel.getHeartTitle(index: viewModel.getSelected()), for: .normal)
        favoriteButton.setImage(viewModel.getHeartForCard(index: viewModel.getSelected()), for: .normal)
        
        if let index = viewModel.getIndexPath() {
            updateCellDelegate?.updateCell(index: index)
        }
    }
    
    @objc func stepperChanged(stepper: UIStepper) {
        let newValue = Int(stepper.value)
        ownedLabel.text = "\(newValue)"
    }
    
    @IBAction func closedTapped(_ sender: UIButton) {
        // save quantity (if changed) here to prevent multiple saves if stepper is repeatedly tapped
        let newValue = Int(stepper.value)
        if newValue != viewModel.getOwnedNumber(index: viewModel.getSelected()) {
            viewModel.changeOwned(quantity: newValue)
            
            if let index = viewModel.getIndexPath() {
                updateCellDelegate?.updateCell(index: index)
            }
        }
            
        self.dismiss(animated: true)
    }
    
}
