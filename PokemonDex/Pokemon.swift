//
//  Pokemon.swift
//  PokemonDex
//
//  Created by Gray Zhen on 7/29/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoImg: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _pokemonURL: String!
    
    var nextEvoName: String{
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String{
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String{
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var name: String{
        return _name
    }
    
    var pokedexID: Int{
        return _pokedexID
    }
    
    var weight: String{
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var nextEvoImg: String{
        
        if _nextEvoImg == nil{
            _nextEvoImg = ""
        }
        return _nextEvoImg
        
    }
    
    
    
    init(name: String, pokedexID: Int){
        
        self._name = name
        self._pokedexID = pokedexID
        
        self._pokemonURL = "\(url_Base)\(url_Pokemon)\(self.pokedexID)/"
        
    }
    
    func downloadingPokeDetail(completed: @escaping downloadCompleted) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
        
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = String(attack)
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = String(defense)
                }
                
                if let types = dict["types"] as? [Dictionary<String,String>], types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += " / \(name.capitalized)"
                            }
                        }
                    }
                    
                }else{
                    self._type = ""
                }
                
                if let descriptionArr = dict["descriptions"] as? [Dictionary<String,String>], descriptionArr.count > 0 {
                
                    if let url = descriptionArr[0]["resource_uri"] {
                        
                        let descURL = url_Base + url
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descriptionData = response.result.value as? Dictionary<String,AnyObject> {
                                
                                if let description = descriptionData["description"] as? String{
                                    
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    self._description = newDescription
                                    
                                }
                                
                            }
                            completed()
                        })
                        
                    }
                    
                }else{
                    self._description = "None"
                }
                
                if let evolution = dict["evolutions"] as? [Dictionary<String,AnyObject>], evolution.count > 0 {
                    
                    if let nextEvo = evolution[0]["to"] as? String{
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvoName = nextEvo
                            
                            if let uri = evolution[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExist = evolution[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvoLvl = String(lvl)
                                        
                                    }
                                    
                                }else{
                                    
                                    self._nextEvoLvl = ""
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            completed()
        }
        
    }
    
}
