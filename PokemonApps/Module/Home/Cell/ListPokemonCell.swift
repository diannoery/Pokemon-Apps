//
//  ListPokemonCell.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import UIKit
import Kingfisher
import RxSwift

class ListPokemonCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var pokemonDetail: PokemoDetailModel?
    
    static let identifier = String(describing: ListPokemonCell.self)
    static let nib = {
        return UINib(nibName: identifier, bundle: nil)
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListPokemonCell {
    func setupViewPokemon(_ data: ResultList) {
        titleLbl.text = data.name

    }
    
    func setupMyPokemonView(_ dataPokemon: PokemoDetailModel) {
        pokemonDetail = dataPokemon
        let imageUrl = URL(string: dataPokemon.sprites.frontDefault ?? "")
        imagePokemon.isHidden = false
        deleteBtn.isHidden = false
        titleLbl.text = dataPokemon.name + "\nNicknames : \(dataPokemon.nickNames ?? "")"
        imagePokemon.kf.setImage(with: imageUrl)
    }
}
