//
//  PokeCell.swift
//  pokedex
//
//  Created by Ron Ramirez on 6/21/16.
//  Copyright © 2016 Mochi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon : Pokemon!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon : Pokemon){
        self.pokemon  = pokemon
        self.nameLbl.text = pokemon.name.capitalizedString
        self.thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }

}
