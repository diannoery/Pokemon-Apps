// 
//  HomeVCInteractor.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import Foundation
import RxSwift

class HomeVCInteractor: BaseInteractor {
    let dataPokemon = PublishSubject<PokemonModel>()
    let dataDetailPokemon = PublishSubject<PokemoDetailModel>()
    
    func fetchDataPokemon(limit:Int, offset:Int) {
        api.getApi(endpoint: .getListPokemon(limit, offset))
            .subscribe{ [weak self] (data: PokemonModel ) in
                guard self != nil else { return }
                self?.dataPokemon.onNext(data)
            } onError: { [weak self] error in
                guard self != nil else { return }
                self?.dataPokemon.onError(error)
            }.disposed(by: bag)
    }
    
    func fectchDetailPokemon(id: Int) {
        api.getApi(endpoint: .getDetailPokemon(id))
            .subscribe{ [weak self] (data: PokemoDetailModel ) in
                guard self != nil else { return }
                self?.dataDetailPokemon.onNext(data)
            } onError: { [weak self] error in
                guard self != nil else { return }
                self?.dataDetailPokemon.onError(error)
            }.disposed(by: bag)
    }
}
