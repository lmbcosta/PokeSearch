//
//  UICollectionView+Ext.swift
//  PokeSearch
//
//  Created by Luis  Costa on 24/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionViewCell: ReusableView{}

extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell> (forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
}
