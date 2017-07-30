//
//  ViewController.swift
//  PokemonDex
//
//  Created by Gray Zhen on 7/29/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self

        parsePokemonCSV()
        
    }
    
    func parsePokemonCSV(){
        
        if let path = Bundle.main.path(forResource: "pokemon", ofType: "csv"){
            
            do{
                
                let csv = try CSV(contentsOfURL: path)
                let rows = csv.rows
                
                for row in rows{
                    
                    let pokeId = Int(row["id"]!)!
                    let name = row["identifier"]!
                    
                    let poke = Pokemon(name: name, pokedexID: pokeId)
                    
                    pokemons.append(poke)
                    
                }
                
            }catch let err as NSError{
                print(err.description)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokemonCell{
            
            let poke = pokemons[indexPath.row]
            
            cell.configureCell(pokemon: poke)
            
            return cell
            
        }else{
            
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pokemons.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
        
    }
    
}

