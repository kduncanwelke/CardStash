//
//  ViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UpdateCellDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortingButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filtersContainer: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var ownedButton: UIButton!
    @IBOutlet weak var decksButton: UIButton!
    @IBOutlet weak var favesButton: UIButton!
    
    // MARK: Variables
    
    private let viewModel = ViewModel()
    
    let tapGestureRecognizer = UITapGestureRecognizer()
    let doubleTapGestureRecognizer = UITapGestureRecognizer()
    let leftSwipeGestureRecognizer = UISwipeGestureRecognizer()
    let rightSwipeGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap(_:)))
        doubleTapGestureRecognizer.addTarget(self, action: #selector(handleDoubleTap(_:)))
        leftSwipeGestureRecognizer.addTarget(self, action: #selector(handleLeftSwipe(_:)))
        rightSwipeGestureRecognizer.addTarget(self, action: #selector(handleRightSwipe(_:)))
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.searchTextField.tintColor = UIColor.lightGray
        
        doubleTapGestureRecognizer.delegate = self
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.collectionView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        tapGestureRecognizer.delegate = self
        self.collectionView.addGestureRecognizer(tapGestureRecognizer)
        
        leftSwipeGestureRecognizer.delegate = self
        leftSwipeGestureRecognizer.direction = .left
        self.collectionView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        rightSwipeGestureRecognizer.delegate = self
        rightSwipeGestureRecognizer.direction = .right
        self.collectionView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search name or Pokedex #", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchBar.searchTextField.leftView?.tintColor = .white
        
        if let clearButton = searchBar.searchTextField.value(forKey: "_clearButton") as? UIButton {
               let templateImage = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
               clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .white
        }
       
        configureSortingPopUpButton()
        
        // core data
        viewModel.loadCards()
        viewModel.loadFaves()
        
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
        if viewModel.isNewSearch() {
            getCards()
        } else {
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
    
    func updateCell(index: IndexPath, wasDeleted: Bool) {
        if wasDeleted {
            collectionView.deleteItems(at: [index])
        } else {
            collectionView.reloadItems(at: [index])
        }
    }
    
    // MARK: IBActions
    
    @IBAction func pressGo(_ sender: UIButton) {
        if filtersContainer.isHidden == false {
            filtersContainer.isHidden = true
        }
        
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
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        performSegue(withIdentifier: "viewCard", sender: Any?.self)
    }
    
    @objc func handleDoubleTap(_ sender: UIGestureRecognizer) {
        viewModel.isFavorite()
        
        if let path = viewModel.getIndexPath() {
            if viewModel.getCardType() == .faves {
                collectionView.deleteItems(at: [path])
            } else {
                collectionView.reloadItems(at: [path])
            }
        }
    }
    
    @objc func handleLeftSwipe(_ sender: UIGestureRecognizer) {
        let location = leftSwipeGestureRecognizer.location(in: self.collectionView)
        let index = self.collectionView.indexPathForItem(at: location)

        if let path = index {
            viewModel.setSelected(index: path.row)
            viewModel.setIndexPath(index: path)
            
            if viewModel.getCardType() == .owned {
                var deleted = viewModel.decreaseOwnedWithDelete()
                if deleted {
                    collectionView.deleteItems(at: [path])
                } else {
                    collectionView.reloadItems(at: [path])
                }
            } else {
                viewModel.decreaseOwnedWithDelete()
                collectionView.reloadItems(at: [path])
            }
        }
    }
    
    @objc func handleRightSwipe(_ sender: UIGestureRecognizer) {
        let location = rightSwipeGestureRecognizer.location(in: self.collectionView)
        let index = self.collectionView.indexPathForItem(at: location)
     
        if let path = index {
            viewModel.setSelected(index: path.row)
            viewModel.setIndexPath(index: path)
            viewModel.increaseOwned()
            collectionView.reloadItems(at: [path])
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       // Don't recognize a single tap until a double-tap fails.
        if gestureRecognizer == self.tapGestureRecognizer &&
            otherGestureRecognizer == self.doubleTapGestureRecognizer {
            return true
       }
       return false
    }
    
    @IBAction func homePressed(_ sender: UIButton) {
        homeButton.tintColor = .white
        ownedButton.tintColor = .tintColor
        decksButton.tintColor = .tintColor
        favesButton.tintColor = .tintColor
        
        activityIndicator.startAnimating()
        viewModel.switchTo(source: .all) { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                self?.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func ownedPressed(_ sender: UIButton) {
        homeButton.tintColor = .tintColor
        ownedButton.tintColor = .white
        decksButton.tintColor = .tintColor
        favesButton.tintColor = .tintColor
        
        activityIndicator.startAnimating()
        viewModel.switchTo(source: .owned) { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                self?.collectionView.reloadData()
            }
        }
    }
    
    @IBAction func decksPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "viewDecks", sender: Any?.self)
    }
    
    @IBAction func favesPressed(_ sender: UIButton) {
        homeButton.tintColor = .tintColor
        ownedButton.tintColor = .tintColor
        decksButton.tintColor = .tintColor
        favesButton.tintColor = .white
        
        activityIndicator.startAnimating()
        viewModel.switchTo(source: .faves) { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.collectionView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cardDetailViewController = segue.destination as? CardDetailViewController else { return }
        cardDetailViewController.updateCellDelegate = self
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
        viewModel.setSelected(index: indexPath.row)
        viewModel.setIndexPath(index: indexPath)
    }
}

