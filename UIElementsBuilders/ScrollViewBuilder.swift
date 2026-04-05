//
//  ScrollViewBuilder.swift
//  TicTacToe
//
//  Created by Dmitry on 3/31/26.
//

import UIKit

/// Creates UIScrollView.
class ScrollViewBuilder: ScrollViewBuilding {
    
    /// Singleton reference.
    static let shared = ScrollViewBuilder()
    
    /// Prevents external initializing.
    private init() {}
    
    /// Creates scroll.
    /// - Returns: UIScrollView
    func createScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }
}
