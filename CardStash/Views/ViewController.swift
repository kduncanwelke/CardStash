//
//  ViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filtersContainer: UIView!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.searchTextField.tintColor = UIColor.lightGray
        
        configurePopUpButton()
        
        viewModel.getInitialCards()
        getCards()
    }
    
    // MARK: Custom functions
    
    func configurePopUpButton() {
        let autoSort = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .auto)
            getCards()
        }
        
        let cardSetAZ = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .cardSetAZ)
            getCards()
        }
        
        let cardSetZA = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .cardSetZA)
            getCards()
        }
        
        let hpLowHigh = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .hpLowHigh)
            getCards()
        }
        
        let hpHighLow = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .hpHighLow)
            getCards()
        }
        
        let nameAZ = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .nameAZ)
            getCards()
        }
        
        let nameZA = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .nameZA)
            getCards()
        }
        
        let numberLowHigh = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .numberLowHigh)
            getCards()
        }
        
        let numberHighLow = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .numberHighLow)
            getCards()
        }
        
        sortingButton.menu = UIMenu(children: [
            UIAction(title: "Sorting (Auto)", handler: autoSort),
            UIAction(title: "Card Set A-Z", handler: cardSetAZ),
            UIAction(title: "Card Set Z-A", handler: cardSetZA),
            UIAction(title: "HP Low-High", handler: hpLowHigh),
            UIAction(title: "HP High-Low", handler: hpHighLow),
            UIAction(title: "Name A-Z", handler: nameAZ),
            UIAction(title: "Name Z-A", handler: nameZA),
            UIAction(title: "Number Low-High", handler: numberLowHigh),
            UIAction(title: "Number High-Low", handler: numberHighLow)
        ])
    }
    
    func getCards() {
        activityIndicator.startAnimating()
        viewModel.getCards(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                self?.collectionView.reloadData()
            }
        })
    }
    
    // MARK: IBActions
    
    @IBAction func pressGo(_ sender: UIButton) {
        if let searchText = searchBar.text {
            viewModel.setSearch(search: searchText)
            getCards()
        }
    }
    
    @IBAction func filtersPressed(_ sender: UIButton) {
        if filtersContainer.isHidden {
            filtersContainer.isHidden = false
        } else {
            filtersContainer.isHidden = true
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCardCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.configure(index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width / 2) - 15.0
        let height = width * 1.6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2.5, bottom: 20, right: 2.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

