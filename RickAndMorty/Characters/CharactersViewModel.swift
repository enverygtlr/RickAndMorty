//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 14.06.2022.
//

import Foundation
import SwiftUI

struct CharacterResponse: Codable, Hashable {
    
    struct Info: Codable, Hashable {
        var count: Int
        var pages: Int
        var next: String?
        var prev: String?
    }
    
    struct Result: Codable, Hashable, Equatable {
        var id: Int
        var name, status, species: String
        var gender: String
        var image: String
        var origin: Origin
        var location: Location
    }
    
    struct Origin: Codable, Hashable {
        var name: String
        var url: String
    }
    
    struct Location: Codable, Hashable {
        var name: String
        var url: String
    }
    
    var info: Info
    var results: [Result]
}

class CharactersViewModel : ObservableObject {
    @Published var characters: [CharacterResponse.Result] = []
    @Published var isLoading = false
    @Published var nameFilter: String?
    
    private var locationFilter: String?
    
    
    private var nextUrl: String?
    private var currentPage = 1
    private(set) var urlList :[String]?
    
    init(urlList: [String]? = nil, locationName: String? = nil) {
        self.urlList = urlList
        self.locationFilter = locationName
    }
    
    func fetch() {
        
        if let urlList = urlList {
            
            for charUrl in urlList {
                guard let url = URL(string: charUrl) else { return }

                let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                    guard let data = data, error == nil else {
                        return
                    }
                        
                    do {
                        let charactersResponse = try JSONDecoder().decode(CharacterResponse.Result.self, from: data)
                        
                        DispatchQueue.main.async {
                            self?.characters.append(charactersResponse)
                        }
                    }
                    catch {
                        print(error)
                    }
                
                    }

                task.resume()
            }
    
        } else {
            fetchDefaultList()
        }
        
    }
    
    func filterCharacters(nameFilter: String)
    {
        characters = characters.filter {$0.name.contains(nameFilter)}
    }
    
    func fetchDefaultList(urlString: String? = "https://rickandmortyapi.com/api/character", shouldAppend: Bool = false, nameFilter :String = "")  {
        
        var urlStr = urlString
        
        if nameFilter != ""
        {
            urlStr = "\(urlStr!)/?name=\(nameFilter.replacingOccurrences(of: " ", with: "+"))"
        }

        guard let url = URL(string: urlStr!) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
                
            do {
                let charactersResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
                
                var charactersToAdd = charactersResponse.results
                
//                if let locationFilter = self?.locationFilter {
//                    charactersToAdd = charactersResponse.results.filter {$0.location.name.contains(locationFilter)}
//                }
//
               
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    if shouldAppend {
                        self?.characters.append(contentsOf: charactersToAdd)
                    } else {
                        self?.characters = charactersToAdd
                    }
                    self?.nextUrl = charactersResponse.info.next
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
        print("NEXT URL= \(nextUrl ?? "EMPTY")")
       
        if let nextUrl = nextUrl {
            isLoading = true
            fetchDefaultList(urlString: nextUrl, shouldAppend: true)
        }
    }
    
}

struct CharTestView: View {
    @ObservedObject var charViewModel = CharactersViewModel(urlList: [
                                                                "https://rickandmortyapi.com/api/character/1",
                                                                "https://rickandmortyapi.com/api/character/45",
                                                                "https://rickandmortyapi.com/api/character/83",
                                                                "https://rickandmortyapi.com/api/character/92"])
    
    var body: some View {
        
        ScrollView {
            VStack {
                Button {
                    charViewModel.fetch()
                } label: {
                    Text("Button")
                }
                                
                ForEach(charViewModel.characters, id: \.self) { character in
                    Text(character.species)
                }
            
            }
        }
        

    
    }
}


struct CharactersTestView_Previews: PreviewProvider {
    
    static var previews: some View {
        CharTestView()
    }
}