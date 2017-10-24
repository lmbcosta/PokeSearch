//
//  ReusableView.swift
//  PokeSearch
//
//  Created by Luis  Costa on 24/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {return String(describing: self)}
}



