//
//  PokemonDetailVC.swift
//  PokemonDex
//
//  Created by Gray Zhen on 8/2/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var pokedexLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexID)")
        
        nameLabel.text = pokemon.name
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLabel.text = String(pokemon.pokedexID)
        
        pokemon.downloadingPokeDetail {
            
            self.updateUI()
            
        }
        
    }
    
    func updateUI() {
        
        weightLabel.text = pokemon.weight
        heightLabel.text = pokemon.height
        attackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            evoLabel.text = "No Evolution"
            nextEvoImg.isHidden = true
        }else{
            nextEvoImg.isHidden = false
            evoLabel.text = "Next Evolution: \(pokemon.nextEvoName) - Lvl \(pokemon.nextEvoLvl)"
            nextEvoImg.image = UIImage(named: String(pokemon.nextEvoId))
        }
        
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }

}
