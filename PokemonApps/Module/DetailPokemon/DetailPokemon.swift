//
//  DetailPokemon.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

class DetailPokemon: UIViewController {
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var width: UILabel!
    @IBOutlet weak var hp: UILabel!
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var defense: UILabel!
    @IBOutlet weak var specialAttack: UILabel!
    @IBOutlet weak var specialDefense: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var typeFirst: UILabel!
    @IBOutlet weak var typeSecond: UILabel!
    @IBOutlet weak var statView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var catchBtn: UIButton!
    
    let bag = DisposeBag()
    var dataDetail: PokemoDetailModel?
    var dataMyPokemon: PokemoDetailModel?
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        catchBtn.rx.tap.subscribe { _ in
            self.catchPokemon()
        }.disposed(by: bag)
        checkMyPokemon()
    }
    
    
    
}

extension DetailPokemon {
    
    // MARK: fungsi untuk mengecek apakah pokemon sudah ditangkap atau belum
    func checkMyPokemon() {
        if let pokemon = Constants.userDefaults.data(forKey: "pokemon") {
            do {
                let data = try JSONDecoder().decode([PokemoDetailModel].self, from: pokemon)
                for item in data {
                    if item.id == dataDetail?.id {
                        catchBtn.isHidden = true
                    }
                }
            } catch {
                print("Error decoding objects: \(error)")
            }
        }
    }
    
    func showAlert(isSucces: Bool) {
        let message =  "Failed to Obtain Pokemon"
        let title = "Failed"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: fungsi untuk menangkap pokemon
    func catchPokemon() {
        let catchSuccess = Bool.random()
        if catchSuccess {
            giveNickNames()
        } else {
            showAlert(isSucces: catchSuccess)
        }
    }
    
    // MARK: fungsi untuk memberikan NickNames pokemon
    func giveNickNames() {
        guard let nav = self.navigationController else { return  }
        let vc = NicknamesView()
        vc.delegate = self
        vc.imageUrl = imageUrl
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        nav.present(vc, animated: true)
    }
    
    // MARK: menyimpan data pokemon yang sudah di tangkap
    func savePokemon() {
        guard let dataPokemon = dataMyPokemon else { return  }
        if let encodedObjects =  Constants.userDefaults.data(forKey: "pokemon") {
            do {
                var objects = try JSONDecoder().decode([PokemoDetailModel].self, from: encodedObjects)
                objects.append(dataPokemon)
                
                let updatedEncodedObjects = try JSONEncoder().encode(objects)
                Constants.userDefaults.set(updatedEncodedObjects, forKey: "pokemon")
                Constants.userDefaults.synchronize()
                catchBtn.isHidden = true
            } catch {
                print("Error decoding/encoding : \(error)")
            }
        } else {
            print("data detail save ",dataPokemon.nickNames)
            let myPokemon = [dataPokemon]
            do {
                let encodedObjects = try JSONEncoder().encode(myPokemon)
                Constants.userDefaults.set(encodedObjects, forKey: "pokemon")
                Constants.userDefaults.synchronize()
                catchBtn.isHidden = true
                showAlert(isSucces: true)
            } catch {
                print("Error encoding : \(error)")
            }
        }
    }
    
    
    func setupView() {
        guard let data = dataDetail else { return  }
        imageUrl = data.sprites.other?.home.frontDefault ?? ""
        let imageUrl = URL(string: data.sprites.other?.home.frontDefault ?? "")
        statView.layer.cornerRadius = 10
        statView.layer.borderWidth = 1
        statView.layer.borderColor = UIColor.gray.cgColor
        typeView.layer.cornerRadius = 10
        typeView.layer.borderWidth = 1
        typeView.layer.borderColor = UIColor.gray.cgColor
        imagePokemon.kf.setImage(with: imageUrl)
        nameLbl.text = data.name
        height.text = "Height : \(data.height)"
        width.text = "Width : \(data.weight)"
        
        for item in data.stats {
            switch item.stat.name {
            case "hp":
                hp.text = "Hp : \(item.baseStat)"
            case "attack":
                attack.text = "Attack : \(item.baseStat)"
            case "defense":
                defense.text = "Defense : \(item.baseStat)"
            case "special-attack":
                specialAttack.text = "Special Attack : \(item.baseStat)"
            case "special-defense":
                specialDefense.text = "Special Defense : \(item.baseStat)"
            case "speed":
                speed.text = "Speed : \(item.baseStat)"
            default:
                break
            }
        }
        
        for item in data.types {
            switch item.slot {
            case 1:
                typeFirst.text = "\(item.type.name)"
            case 2:
                typeSecond.text = "\(item.type.name)"
            default:
                break
            }
        }
        
        
        
        
    }
}

extension DetailPokemon: NickNamesDelegate {
    func nickNames(name: String) {
        guard var data = dataDetail else { return  }
        print("ini nama ", name)
        data.nickNames = name
        dataMyPokemon = data
        savePokemon()
    }
    
    
}
