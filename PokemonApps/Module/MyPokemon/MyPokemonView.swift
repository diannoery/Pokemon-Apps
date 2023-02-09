// 
//  MyPokemonView.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import UIKit
import RxSwift
import RxCocoa

class MyPokemonView: UIViewController {
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var emptyPokemon: UIView!
    
    let bag = DisposeBag()
    var presenter: MyPokemonPresenter?
    var dataPokemon: [PokemoDetailModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        registerTabel()
    }
    
    func registerTabel() {
        listTable.register(ListPokemonCell.nib, forCellReuseIdentifier: ListPokemonCell.identifier)
        listTable.delegate = self
        listTable.dataSource = self
        
    }
    
    // MARK: Fungsi untuk cek data pokemon yang sudah ditangkap dan di simpan di userdefault
    func setData() {
        if let pokemon = Constants.userDefaults.data(forKey: "pokemon") {
            do {
                let data = try JSONDecoder().decode([PokemoDetailModel].self, from: pokemon)
                if data.isEmpty {
                    emptyPokemon.isHidden = false
                } else {
                    self.dataPokemon = data
                }
            } catch {
                print("Error decoding objects: \(error)")
            }
        } else {
            emptyPokemon.isHidden = false
        }
    }
    
    func removeMyPokemon(id: Int) {
        if let index = dataPokemon.firstIndex(where: {  $0.id == id}) {
            dataPokemon.remove(at: index)
        }
        
        // MARK: Fungsi untuk update data yang diremove di userdefault
        if let pokemon = Constants.userDefaults.data(forKey: "pokemon") {
            do {
                var data = try JSONDecoder().decode([PokemoDetailModel].self, from: pokemon)
                
                if let index = data.firstIndex(where: { $0.id == id }) {
                    data.remove(at: index)
                }
                
                let modifiedData = try JSONEncoder().encode(data)
                Constants.userDefaults.set(modifiedData, forKey: "pokemon")
                listTable.reloadData()
                emptyPokemon.isHidden = dataPokemon.isEmpty ? false : true
            } catch {
                print("Error decoding/encoding objects: \(error)")
            }
        }
        
    }
    
}

extension MyPokemonView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataPokemon[indexPath.item]
        guard let cell = listTable.dequeueReusableCell(
            withIdentifier: String(describing: ListPokemonCell.self),
            for: indexPath) as? ListPokemonCell
        else { return UITableViewCell() }
        print("ini data nicknames ", data.nickNames)
        cell.setupMyPokemonView(data)
        cell.deleteBtn.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                print("Button clicked for pokemon: \(data.id)")
                self.removeMyPokemon(id: data.id)
            }).disposed(by: bag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

