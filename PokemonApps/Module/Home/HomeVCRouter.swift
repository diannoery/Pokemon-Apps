// 
//  HomeVCRouter.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import UIKit

class HomeVCRouter {
    
    func showView() -> HomeVCView {
        let interactor = HomeVCInteractor()
        let presenter = HomeVCPresenter(interactor: interactor)
        let view = HomeVCView(nibName: String(describing: HomeVCView.self), bundle: nil)
        view.presenter = presenter
        return view
    }
    
    
    func navigateDetail(nav: UINavigationController, data: PokemoDetailModel) {
        let vc = DetailPokemon()
        vc.dataDetail = data
        vc.title = "Detail Pokemon"
        nav.pushViewController(vc, animated: true)
    }
    
    func navigateMyPokemon(nav: UINavigationController) {
        let vc = MyPokemonView()
        nav.pushViewController(vc, animated: true)
    }
    
}
