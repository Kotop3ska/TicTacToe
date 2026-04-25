//
//  ImageViewBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates and configures a UIImageView with the given image.
class ImageViewFactory: ImageViewCreating {
    
    /// Singleton reference.
    static let shared = ImageViewFactory()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Module bundle for loading resources.
    private let bundle = Bundle(for: ImageViewFactory.self)
    
    /// Creates a UIImageView with an image by name.
    /// - Parameter name: Image name in project resources
    /// - Returns: Customized UIImageView
    func createImageView(name: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: name, in: bundle, with: nil)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
}
