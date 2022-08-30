//
//  PhotoCollectionViewController.swift
//  Photo Search
//
//  Created by Anton Duplin on 25/8/22.
//

import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    var results: [UnsplashPhoto] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }

  //   MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
        
        
        var unsplashPhoto: UnsplashPhoto
        unsplashPhoto = results[indexPath.item]
        guard let photoChoose = segue.destination as? MyPhotoViewController else { return }
        photoChoose.photo = unsplashPhoto
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        let photoUnsplash = results[indexPath.item]
        cell.configure(with: photoUnsplash)
 
        return cell
    }
    
    private func fetchImages () {
        NetworkManager.shared.fetchImages(query: "random") { searchResult in
            self.results = searchResult!.results
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Setup UI Elements
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = false
        seacrhController.searchBar.delegate = self
    }

}
// MARK: UISearchBarDelegate
extension PhotoCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchbar: UISearchBar, textDidChange searchText: String) {
        if let text = searchbar.text {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            self.results = []
                
                NetworkManager.shared.fetchImages(query: text)  { [weak self] (searchResults) in
                    guard let fetchedPhotos = searchResults else { return }
                    self?.results = fetchedPhotos.results
                    self?.collectionView.reloadData()
                }
            })
        }
        
    }
}
extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingWidth = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
    
