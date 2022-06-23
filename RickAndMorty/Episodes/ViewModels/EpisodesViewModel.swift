//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 19.06.2022.
//

import Foundation
import SwiftUI

struct EpisodesResponse: Codable, Hashable {
    
    struct Info: Codable, Hashable {
        var count: Int
        var pages: Int
        var next: String?
        var prev: String?
    }
    
    struct Result: Codable, Hashable, Equatable {
        var id: Int
        var name, air_date, episode: String
        var characters: [String]?
    }
    
    var info: Info
    var results: [Result]
}

class EpisodesViewModel : ObservableObject {
    @Published var episodes: [EpisodesResponse.Result] = []
    @Published var isLoading = false
    private var nextUrl: String?
    
    func fetch(url: URL? = nil,nameFilter :String? = nil, shouldAppend: Bool = false) {
        
        
        Utility.fetch(type: EpisodesResponse.self, url: url ?? RickAndMortyAPI.episodes(name: nameFilter).url!)
        { episodesResponse in
            self.isLoading = false
            
            if shouldAppend {
                self.episodes.append(contentsOf: episodesResponse.results)
            } else {
                self.episodes = episodesResponse.results
            }
            self.nextUrl = episodesResponse.info.next
        }
    }
    
    func loadNextPage()
    {
        if let nextUrl = nextUrl {
            guard let url = URL(string: nextUrl) else { return }
            isLoading = true
            fetch(url: url, shouldAppend: true)
        }
    }
    

}
