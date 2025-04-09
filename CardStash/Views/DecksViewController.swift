//
//  DecksViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 3/21/25.
//

import Foundation
import UIKit

class DecksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
    
    @IBAction func homePressed(_ sender: UIButton) {
        // TODO: Show correct button selected
        self.dismiss(animated: false)
    }
    
    @IBAction func ownedPressed(_ sender: UIButton) {
        // TODO: Show correct button selected
        self.dismiss(animated: false)
    }
    
    @IBAction func favesPressed(_ sender: UIButton) {
        // TODO: Show correct button selected
        self.dismiss(animated: false)
    }
}

extension DecksViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deckCell", for: indexPath) as! DeckCollectionViewCell
        
        //cell.configure(index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width - 15.0
        let height = width * 0.44
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}
