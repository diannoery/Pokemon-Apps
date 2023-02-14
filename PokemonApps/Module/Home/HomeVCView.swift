// 
//  HomeVCView.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class HomeVCView: UIViewController {
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var myPokemonBtn: UIButton!
    @IBOutlet weak var loading: UIView!
    @IBOutlet weak var loadingIdicator: UIActivityIndicatorView!
    
    let activityIndicator = UIActivityIndicatorView()
    let bag = DisposeBag()
    var presenter: HomeVCPresenter?
    var dataPokemon: [ResultList] = []
    var dataDetailPokemon: PokemoDetailModel?
    var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: hit data list Pokemon
        presenter?.getListPokemon(limit: 10, offset: page).subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.dataPokemon.append(contentsOf: data.results)
            self.listTable.reloadData()
        }).disposed(by: bag)
        
        setupClick()
        listTable.register(ListPokemonCell.nib, forCellReuseIdentifier: ListPokemonCell.identifier)
        listTable.delegate = self
        listTable.dataSource = self
        listTable.tableFooterView = activityIndicator
        activityIndicator.style = .medium
        activityIndicator.color = .gray
        myPokemonBtn.layer.cornerRadius = 10
        
    }
    
    
    
    
}

extension HomeVCView {
    
    func setupClick() {
        myPokemonBtn.rx.tap.subscribe { _ in
            self.navigateMyPokemon()
        }.disposed(by: bag)
    }
    
    // MARK: fungsi untuk pindah ke halaman detail
    func navigateDetail() {
        guard let data = dataDetailPokemon, let nav = self.navigationController else { return  }
        presenter?.navigateDetail(nav: nav, data: data)
    }
    
    // MARK: fungsi untuk pindah ke halaman Mypokemon
    func navigateMyPokemon() {
        guard let nav = self.navigationController else { return  }
        presenter?.navigateMyPokemon(nav: nav)
    }
    
    // MARK: fungsi untuk hit data detail dari pokemon
    func getDetail(id: Int) {
        loading.isHidden = false
        loadingIdicator.startAnimating()
        loadingIdicator.hidesWhenStopped = true
        listTable.allowsSelection = false
        presenter?.getDetailPokemon(id: id)
            .take(1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.dataDetailPokemon = data
                self.navigateDetail()
                self.loadingIdicator.stopAnimating()
                self.loading.isHidden = true
                self.listTable.allowsSelection = true
            }).disposed(by: bag)
    }
    
    // MARK: fungsi untuk endless scroll
    func loadMoreData() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        page += 10
        presenter?.getListPokemon(limit: 10, offset: page)
            .take(1)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.dataPokemon.append(contentsOf: data.results)
                self.activityIndicator.stopAnimating()
                self.listTable.reloadData()
            }).disposed(by: bag)
        
    }
}

extension HomeVCView:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dataPokemon[indexPath.item]
        guard let cell = listTable.dequeueReusableCell(
            withIdentifier: String(describing: ListPokemonCell.self),
            for: indexPath) as? ListPokemonCell
        else { return UITableViewCell() }
        
        cell.setupViewPokemon(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataPokemon[indexPath.item]
        let urlString = data.url
        let components = urlString.split(separator: "/")
        let lastComponent = components.last ?? "0"
        let lastInt = Int(lastComponent)
        getDetail(id: lastInt ?? 0)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataPokemon.count - 1 {
            loadMoreData()
        }
    }
    
}
