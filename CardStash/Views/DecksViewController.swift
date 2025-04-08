//
//  DecksViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/21/25.
//

import Foundation
import UIKit

class DecksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var deckCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deckCollectionView.dataSource = self
        deckCollectionView.delegate = self
    }
    
    // MARK: Custom functions
    
    // MARK: IBActions
    
    @IBAction func addNewPressed(_ sender: UIButton) {
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deckCell", for: indexPath) as! DeckCollectionViewCell
        
        //cell.configure(index: indexPath.row)
        
        return cell
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ownedPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func favesPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
