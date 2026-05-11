//
//  UICollectionView+GridLayout.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 8/05/26.
//

import UIKit

extension UICollectionView {

    func movieGridItemSize(columns: Int, spacing: CGFloat = 10, insets: CGFloat = 32) -> CGSize {
        let columns = CGFloat(columns)
        let availableWidth = bounds.width - insets - (spacing * (columns - 1))
        let itemWidth = floor(availableWidth / columns)
        return CGSize(width: itemWidth, height: itemWidth * 1.4 + 44)
    }
}
