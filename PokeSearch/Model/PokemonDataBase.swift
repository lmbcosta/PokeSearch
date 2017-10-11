//
//  PokemonDataBase.swift
//  PokeSearch
//
//  Created by Luis  Costa on 11/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import Foundation

class PokemonDatabase {
    static var shared = PokemonDatabase()
    
    private var pokemonArray = [Pokemon]()
    private var pokemonDictionary = [String:Pokemon]()
    
    func getPokemonArray() -> [Pokemon] {
        return pokemonArray
    }
    
    func getPokemonDictionary() -> [String:Pokemon] {
        return pokemonDictionary
    }
    
    private init() {
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv") {
            do {
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows {
                    let id = Int(row["id"]!)!
                    let name = row["identifier"]!
                    
                    let pokemon = Pokemon(id: id, name: name)
    
                    // Add to array and to the dixtionary
                    pokemonArray.append(pokemon)
                    pokemonDictionary[name] = pokemon
                }
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    
}
