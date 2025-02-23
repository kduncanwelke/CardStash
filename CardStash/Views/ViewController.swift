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
        
        configureSortingPopUpButton()
        
        viewModel.getInitialCards()
        getCards()
    }
    
    // MARK: Custom functions
    
    func searchAndSort() {
        if let searchText = searchBar.text {
            viewModel.setSearch(search: searchText, completion: { [weak self] in
                self?.reloadForSorting()
            })
        }
    }
    
    func configureSortingPopUpButton() {
        let autoSort = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .auto, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let cardSetAZ = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .cardSetAZ, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let cardSetZA = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .cardSetZA, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let hpLowHigh = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .hpLowHigh, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let hpHighLow = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .hpHighLow, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let nameAZ = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .nameAZ, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let nameZA = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .nameZA, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let numberLowHigh = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .numberLowHigh, completion: { [weak self] in
                self?.searchAndSort()
            })
        }
        
        let numberHighLow = { [unowned self] (action: UIAction) in
            self.viewModel.setSorting(kind: .numberHighLow, completion: { [weak self] in
                self?.searchAndSort()
            })
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
    
    func reloadForSorting() {
        print(SearchParameters.isNewSearch)
        if viewModel.isNewSearch() {
            getCards()
            print("api call")
        } else {
            print("reload")
            activityIndicator.startAnimating()
            collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
            collectionView.reloadData()
            activityIndicator.stopAnimating()
        }
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
            viewModel.setSearch(search: searchText, completion: { [weak self] in
                self?.getCards()
            })
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

