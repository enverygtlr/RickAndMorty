//
//  LocationsView.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 13.06.2022.
//

import SwiftUI

struct LocationsView: View {
    @ObservedObject var locViewModel = LocationsViewModel()

    @State var searchText = ""
    @State var isSearching = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20.0) {
                
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                {
                    self.locViewModel.fetch(nameFilter: self.searchText)
                }
                
                ForEach(locViewModel.locations, id: \.self) { location in
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(location.name)
                                .bold()
                                .font(.title)
                            
                            Text("Type: \(location.type)")
                            
                            Text("Dimension: \(location.dimension)")
                        }
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: CharactersView(urlList: location.residents, locationName: location.name))
                        {
                                Text("Characters")
                                    .foregroundColor(Color.black)
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(.green)
                                    )
                        }
                        
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.gray)
                            .shadow(color: .black, radius: 4, x: 0, y: 1))
                    .padding(5)
                    .onAppear {
                        if(location == locViewModel.locations.last)
                        {
                            locViewModel.loadNextPage()
                        }
                    }
                    
                    
                     if(locViewModel.isLoading)
                     {
                         ProgressView()
                     }
             
                    
                }
                
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(
                           colors: [.green, .yellow]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
        .navigationBarTitle("Locations")
        .onAppear() {
            locViewModel.fetch()
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    
    static var previews: some View {
        LocationsView()
    }
}
