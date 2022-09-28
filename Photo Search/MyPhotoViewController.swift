//
//  MyPhotoViewController.swift
//  Photo Search
//
//  Created by Anton Duplin on 28/8/22.
//

import UIKit

class MyPhotoViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: UnsplashPhoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
 
    
    private func fetchImage () {
        guard let url = URL(string: photo.urls.small_s3) else { return }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
