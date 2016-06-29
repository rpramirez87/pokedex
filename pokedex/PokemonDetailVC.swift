 //
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Ron Ramirez on 6/22/16.
//  Copyright © 2016 Mochi. All rights reserved.
//
 import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var pokemonNameLbl: UILabel!
    var pokemon : Pokemon!
    @IBOutlet weak var pokemonImg: UIImageView!
    
    @IBOutlet weak var pokemonTypeLbl: UILabel!
    @IBOutlet weak var pokemonDescLbl: UILabel!
    @IBOutlet weak var pokedexIDLbl: UILabel!
    @IBOutlet weak var pokemonHeightLbl: UILabel!
    @IBOutlet weak var pokemonBaseAttackLbl: UILabel!
    @IBOutlet weak var pokemonEvolutionDescLbl: UILabel!
    @IBOutlet weak var pokemonWeightLbl: UILabel!
    @IBOutlet weak var pokemonDefenseLbl: UILabel!
    
    
    //Evolutions
    @IBOutlet weak var pokemonCurrentEvol: UIImageView!
    @IBOutlet weak var pokemonNextEvol: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonNameLbl.text = pokemon.name.capitalizedString
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        pokemonImg.image = img
        pokedexIDLbl.text = "\(pokemon.pokedexId)"
        
        pokemonCurrentEvol.image = img
        pokemonNextEvol.image = UIImage(named: "\(pokemon.pokedexId + 1)")
        
        
        pokemon.downloadPokemonDetails { () -> () in
            //This will be called after download is done.
            print("DID WE GET HERE!")
            self.updateUI()
             
        }
    }
    
    func updateUI() {
        pokemonTypeLbl.text = pokemon.type
        pokemonDescLbl.text = pokemon.description
        pokemonHeightLbl.text = pokemon.height
        pokemonWeightLbl.text = pokemon.weight
        pokemonBaseAttackLbl.text = pokemon.attack
        pokemonDefenseLbl.text = pokemon.defense
        
        //Next-Evolution
        if pokemon.nextEvolutionID == ""{
            pokemonEvolutionDescLbl.text = "No Evolution"
            pokemonNextEvol.hidden = true
        }else{
            pokemonNextEvol.hidden = false
            pokemonNextEvol.image = UIImage(named: pokemon.nextEvolutionID)
            
            var str = "Evolution : \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLVL != "" {
                str += " - LVL: \(pokemon.nextEvolutionLVL)"
                
            }
            pokemonEvolutionDescLbl.text = str
        }
    }
    @IBAction func backButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
