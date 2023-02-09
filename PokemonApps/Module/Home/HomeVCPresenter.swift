// 
//  HomeVCPresenter.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import Foundation
import RxSwift

class HomeVCPresenter {
    
    private let interactor: HomeVCInteractor
    private let router = HomeVCRouter()
    
    init(interactor: HomeVCInteractor) {
        self.interactor = interactor
    }
    
    func getListPokemon(limit: Int, offset: Int) -> PublishSubject<PokemonModel> {
        interactor.fetchDataPokemon(limit: limit, offset: offset)
        return interactor.dataPokemon
    }
    
    func getDetailPokemon(id: Int) -> PublishSubject<PokemoDetailModel> {
        interactor.fectchDetailPokemon(id: id)
        return interactor.dataDetailPokemon
    }
    
    func navigateDetail(nav: UINavigationController, data: PokemoDetailModel) {
        router.navigateDetail(nav: nav, data: data)
    }
    
    func navigateMyPokemon(nav: UINavigationController) {
        router.navigateMyPokemon(nav: nav)
    }
    
    
    
    
}
