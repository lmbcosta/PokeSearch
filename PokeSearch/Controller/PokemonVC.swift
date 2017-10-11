//
//  PokemonVC.swift
//  PokeSearch
//
//  Created by Luis  Costa on 10/10/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit

protocol PokemonDelegate {
    func insertPokemonOnMap(pokemon: Pokemon)
}

class PokemonVC: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // Variables
    var pokemons: [Pokemon]!
    var filteredPokemons: [Pokemon] = []
    var delegate: PokemonDelegate?
    var isInFilterMode = false // Filter text from searchbar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Search bar: Search button is done
        searchBar.returnKeyType = UIReturnKeyType.done
        
        pokemons = PokemonDatabase.shared.getPokemonArray()
    }
    
    private func closeKeyboard() {
        view.endEditing(true)
    }
    
    private func getPokeArray() -> [Pokemon] {
        return isInFilterMode ? filteredPokemons : pokemons
    }
}

// Mark: - UISearchDelegate
extension PokemonVC: UISearchBarDelegate {
    // Close Keyboard
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        closeKeyboard()
    }
    
    // Select button search should close keyboard
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            let search = searchText.lowercased()
            filteredPokemons = pokemons.filter{$0.name.range(of: search) != nil}
            isInFilterMode = true
        } else {
            isInFilterMode = false
            view.endEditing(true)
        }
        // In both cases reload data
        collectionView.reloadData()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        closeKeyboard()
    }
}

// Mark: - UICollectionView protocols
extension PokemonVC: UICollectionViewDataSource, UICollectionViewDelegate {
    // Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getPokeArray().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokeArray = getPokeArray()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as? PokemonCell {
            cell.setPokeCell(pokemon: pokeArray[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    // Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemon = getPokeArray()[indexPath.row]
        delegate?.insertPokemonOnMap(pokemon: pokemon)
        dismiss(animated: true, completion: nil)
    }
    
}











