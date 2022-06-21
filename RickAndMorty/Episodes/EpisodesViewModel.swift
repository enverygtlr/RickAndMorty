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
    
    func fetch(urlString: String? = "https://rickandmortyapi.com/api/episode", nameFilter :String = "", shouldAppend: Bool = false) {
        
        var urlStr = urlString!
        
        if nameFilter != ""
        {
            urlStr = "\(urlStr)/?name=\(nameFilter.replacingOccurrences(of: " ", with: "+"))"
            
            print("NEW URL: \(urlStr)")
        }
        
        guard let url = URL(string: urlStr) else { return }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
                
            do {
                let episodesResponse = try JSONDecoder().decode(EpisodesResponse.self, from: data)
                
                 DispatchQueue.main.async {
                    self?.isLoading = false

                    if shouldAppend {
                        self?.episodes.append(contentsOf: episodesResponse.results)
                    } else {
                        self?.episodes = episodesResponse.results
                    }
                    
                    self?.nextUrl = episodesResponse.info.next
                }
            }
            catch {
                print(error)
            }
        }

        task.resume()
        
    }
    
    func loadNextPage()
    {
        if let nextUrl = nextUrl {
            isLoading = true
            fetch(urlString: nextUrl, shouldAppend: true)
        }
    }
    
    
}