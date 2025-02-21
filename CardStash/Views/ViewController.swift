//
//  ViewController.swift
//  CardStash
//
//  Created by Katherine Duncan-Welke on 2/19/25.
//

import UIKit
import Nuke

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Variables
    
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.searchTextField.tintColor = UIColor.lightGray
    }
    
    // MARK: Custom functions
    
    func getCards() {
        viewModel.getCards(completion: { [weak self] in
            DispatchQueue.main.async {
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
    }
   
   
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCardCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.name.text = viewModel.getCardName(index: indexPath.row)
        cell.HP.text = viewModel.getCardHP(index: indexPath.row)
        cell.set.text = viewModel.getCardSet(index: indexPath.row)
        cell.cardImage.image = UIImage(named: "cardplaceholder")
        
        DispatchQueue.main.async {
            if let url = self.viewModel.getImageURL(index: indexPath.row) {
                let request = ImageRequest(url: url, processors: [ImageProcessors.Resize(size: CGSize(width: self.view.frame.width, height: self.view.frame.height), contentMode: ImageProcessors.Resize.ContentMode.aspectFill)])
                
                Nuke.loadImage(with: request, options: NukeOptions.options, into: cell.cardImage) { response, completed, total in
                    if response != nil {
                        cell.cardImage.image = response?.image
                    } else {
                        cell.cardImage.image = NukeOptions.options.failureImage
                    }
                }
            }
        }
        
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

