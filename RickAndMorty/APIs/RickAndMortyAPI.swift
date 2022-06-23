//
//  RickAndMortyAPI.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 23.06.2022.
//

import Foundation


enum RickAndMortyAPI {
    case locations(pageIndex: Int? = nil, name: String? = nil)
    case episodes(pageIndex: Int? = nil, name: String? = nil)
    case characters(pageIndex: Int? = nil, name: String? = nil)
    
    var url: URL? {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "rickandmortyapi.com"
        component.path = path
        component.queryItems = pageQuery()
        return component.url
    }
    
    private func pageQuery()-> [URLQueryItem]? {
        switch self {
        case .locations(pageIndex: let page, name: let name):
            fallthrough
        case .episodes(pageIndex: let page, name: let name):
            fallthrough
        case .characters(pageIndex: let page, name: let name):
            var queryArray: [URLQueryItem] = []
            
            if let page = page {
                queryArray.append(URLQueryItem(name: "page", value: page.description))
            }
            
            if let name = name {
                queryArray.append(URLQueryItem(name: "name", value: name))
            }
            
            if (!queryArray.isEmpty) {
                return queryArray
            } else {
                return nil
            }
        }
    }
}

extension RickAndMortyAPI {
    fileprivate var path: String {
        switch self {
        case .locations:
            return "/api/location"
        case .episodes:
            return "/api/episode"
        case .characters:
            return "/api/character"
        }
    }
}
