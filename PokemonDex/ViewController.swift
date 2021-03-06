//
//  ViewController.swift
//  PokemonDex
//
//  Created by Gray Zhen on 7/29/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var searchedPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done

        parsePokemonCSV()
        initMusic()
        
    }
    
    func initMusic(){
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
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
                print(err.debugDescription)
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokemonCell{
            
            let poke: Pokemon!
            
            if inSearchMode{
                
                poke = searchedPokemons[indexPath.row]
                
            }else{
                
                poke = pokemons[indexPath.row]
                
            }
            
            cell.configureCell(pokemon: poke)
            
            return cell
            
        }else{
            
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode{
            
            poke = searchedPokemons[indexPath.row]
            
        }else{
            
            poke = pokemons[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            
            return searchedPokemons.count
            
        }else{
            
            return pokemons.count
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (screenSize.width - 60) / 3, height: (screenSize.width - 40) / 3)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            collection.reloadData()
            
            view.endEditing(true)
            
        }else{
            
            inSearchMode = true
            
            let lowerText = searchBar.text!.lowercased()
            
            searchedPokemons = pokemons.filter({$0.name.range(of: lowerText) != nil})
            
            collection.reloadData()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            
            if let detail = segue.destination as? PokemonDetailVC {
                
                if let poke = sender as? Pokemon {
                    
                    detail.pokemon = poke
                    
                }
                
            }
            
        }
        
    }
    
    @IBAction func musicBtn(_ sender: UIButton) {
        
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
        
    }
    
}

