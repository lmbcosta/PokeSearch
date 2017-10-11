//
//  Pokemon.swift
//  PokeSearch
//
//  Created by Luis  Costa on 10/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation

struct Pokemon {
    private var _id: Int!
    private var _name: String!
    
    var id: Int {return _id}
    var name: String {return _name}
    
    init(id: Int, name: String) {
        _id = id
        _name = name
    }
}
