//
//  LocationsViewModel.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 13.06.2022.
//

import Foundation
import SwiftUI

struct LocationsResponse: Codable, Hashable {
    
    struct Info: Codable, Hashable {
        var count: Int
        var pages: Int
        var next: String?
        var prev: String?
    }
    
    struct Result: Codable, Hashable, Equatable {
        var id: Int
        var name, dimension: String
        var type: String
        var residents: [String]
        var url: String
        var created: String
    }
        
    var info: Info
    var results: [Result]
    
}

class LocationsViewModel : ObservableObject {
    @Published var locations: [LocationsResponse.Result] = []
    @Published var isLoading = false
    @Published var dataText = ""
   
    private var nextUrl: String?

    
    func fetch(urlString: String? = "https://rickandmortyapi.com/api/location", nameFilter :String = "", shouldAppend: Bool = false) {
        
        var urlStr = urlString!
        
        if nameFilter != ""
        {
            urlStr = "\(urlStr)/?name=\(nameFilter.replacingOccurrences(of: " ", with: "+"))"
        }
        
        
        Utility.fetch(type: LocationsResponse.self, urlString: urlStr)
        { locationsResponse in
            self.isLoading = false
            
            if shouldAppend {
                self.locations.append(contentsOf: locationsResponse.results)
            } else {
                self.locations = locationsResponse.results
            }
            
            self.nextUrl = locationsResponse.info.next
        }
        
        
    }
    
    func loadNextPage()
    {
        if let nextUrl = nextUrl {
            isLoading = true
            fetch(urlString: nextUrl, shouldAppend: true)
        }
    }
    
    
}

struct TestView: View {
    @ObservedObject var locViewModel = LocationsViewModel()
    
    var body: some View {
        
        ScrollView {
            VStack {
            
                Button {
                    locViewModel.fetch()
                } label: {
                    Text("Button")
                }
                
                Text("\(locViewModel.dataText)")
            
            }
        }
    }
}


struct LocationView_Previews: PreviewProvider {
    
    static var previews: some View {
        TestView()
    }
}
