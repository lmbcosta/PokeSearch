//
//  PokemonCell.swift
//  PokeSearch
//
//  Created by Luis  Costa on 10/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

class PokemonCell: UICollectionViewCell {
    
    @IBOutlet weak var pokeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setPokeCell(pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        if let image = UIImage(named: "\(pokemon.id)") {
            pokeImage.image = image
        }
    }
}
