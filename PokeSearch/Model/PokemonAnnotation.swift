//
//  PokemonAnnotation.swift
//  PokeSearch
//
//  Created by Luis  Costa on 04/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var id: Int
    var title: String?
    
    init(id: Int, title: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
    }
}
