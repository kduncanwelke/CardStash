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
    @IBOutlet weak var weakness: UILabel!
    @IBOutlet weak var resistance: UILabel!
    @IBOutlet weak var retreatCost: UILabel!
    @IBOutlet weak var flavorText: UILabel!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadCard()
    }
    
    // MARK: Custom functions
    
    func loadCard() {
        name.text = viewModel.getCardName(index: viewModel.getSelected())
        number.text = viewModel.getCardNumber(index: viewModel.getSelected())
        cardSet.text = viewModel.getCardSet(index: viewModel.getSelected())
        hp.text = viewModel.getCardHP(index: viewModel.getSelected())
        type.text = viewModel.getCardType(index: viewModel.getSelected())
        stage.text = viewModel.getCardStage(index: viewModel.getSelected())
        weakness.text = viewModel.getCardWeakness(index: viewModel.getSelected())
        resistance.text = viewModel.getCardResistance(index: viewModel.getSelected())
        retreatCost.text = viewModel.getCardRetreatCost(index: viewModel.getSelected())
        flavorText.text = viewModel.getCardFlavorText(index: viewModel.getSelected())
        
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
    
    @IBAction func closedTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
