//
//  CollectionViewCell.swift
//  Photo Search
//
//  Created by Anton Duplin on 26/8/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: imageView!
    
    func configure(with photo: UnsplashPhoto) {
        imageView.fetchImage(from: photo.urls.regular)
    }
}
