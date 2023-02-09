//
//  NicknamesView.swift
//  PokemonApps
//
//  Created by Dian Noery on 09/02/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol NickNamesDelegate {
    func nickNames(name: String)
}

class NicknamesView: UIViewController {
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var nicknames: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    let bag = DisposeBag()
    var delegate: NickNamesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.rx.tap
            .subscribe(onNext: { _ in
                let name = self.nicknames.text ?? ""
                self.delegate?.nickNames(name: name)
                self.dismiss(animated: true)
            }).disposed(by: bag)
    }



}
