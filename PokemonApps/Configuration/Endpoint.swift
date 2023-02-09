//
//  Endpoint.swift
//  PokemonApps
//
//  Created by Dian Noery on 08/02/23.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

enum Endpoint {
    case getListPokemon(Int, Int)
    case getDetailPokemon(Int)
    
    func path() -> String {
        switch self {
        case .getListPokemon:
            return "/pokemon"
        case .getDetailPokemon(let id):
            return "/pokemon/\(id)"
        }
    }
    // MARK: - HTTPMethod
    func method() -> HTTPMethod {
        switch self {
        case .getListPokemon:
            return .get
        case .getDetailPokemon(_):
            return .get
        }
    }
    // MARK: - Parameters
    var parameters: [String: Any]? {
        switch self {
        case .getListPokemon(let limit, let offset):
            let params: [String: Any] = [
                "limit" : limit,
                "offset" : offset
            ]
            return params
        case .getDetailPokemon(_):
            let params: [String: Any] = [:]
            return params
        }
    }
    
    // MARK: - Headers
    var headers: HTTPHeaders {
        switch self {
        case .getListPokemon:
            let params: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            return params
        case .getDetailPokemon(_):
            let params: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            return params
        }
        
    }
    
    func urlString() -> String {
        return Constants.baseURL + path()
    }
}
