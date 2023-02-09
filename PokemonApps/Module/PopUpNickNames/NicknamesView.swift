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
    @IBOutlet weak var contentView: UIView!
    
    let bag = DisposeBag()
    var delegate: NickNamesDelegate?
    var imageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageUrl = URL(string: imageUrl)
        saveBtn.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 20
        saveBtn.rx.tap
            .subscribe(onNext: { _ in
                let name = self.nicknames.text ?? ""
                self.delegate?.nickNames(name: name)
                self.dismiss(animated: true)
            }).disposed(by: bag)
        pokemonImg.kf.setImage(with: imageUrl)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
