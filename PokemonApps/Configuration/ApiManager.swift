//
//  ApiManager.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift


class BaseInteractor {
    var api = ApiManage()
    var bag = DisposeBag()
}

class ApiManage {
    func getApi<T: Codable>(endpoint: Endpoint) -> Observable<T> {
        
        print("ini parameter ", endpoint.parameters)
        print("ini url ", endpoint.urlString())
        print("ini header ", endpoint.headers)
        
        return Observable.create { observer in
            request(
                endpoint.method(),
                endpoint.urlString(),
                parameters: endpoint.parameters,
                headers: endpoint.headers,
                interceptor: nil
            ).flatMap {
                $0.rx.data()
               
            }
            .observe(on: MainScheduler.instance)
            .decode(type: T.self, decoder: JSONDecoder())
            .subscribe{ data in
                observer.onNext(data)
                observer.onCompleted()
            } onError: { error in
                print(error.localizedDescription)
                print("ini eror", error)
                observer.onError(error)
            }
        }
    }
}
