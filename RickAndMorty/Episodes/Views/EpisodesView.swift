//
//  EpisodesView.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 19.06.2022.
//

import SwiftUI

struct EpisodesView: View {
    @ObservedObject var epiViewModel = EpisodesViewModel()
    
    @State var searchText = ""
    @State var isSearching = false

    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20.0) {
                
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                {
                    self.epiViewModel.fetch(nameFilter: self.searchText)
                }
                
                ForEach(epiViewModel.episodes, id: \.self) { episode in
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(episode.name)
                                .bold()
                                .font(.title)
                            Text("Episode: \(episode.episode)")
                            Text("Date: \(episode.air_date)")
                        }
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: CharactersView(urlList: episode.characters))
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
                        if(episode == epiViewModel.episodes.last){
                            epiViewModel.loadNextPage()
                        }
                    }
                     if(epiViewModel.isLoading) {
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
            epiViewModel.fetch()
        }
    }
}

struct EpisodesView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesView()
    }
}
