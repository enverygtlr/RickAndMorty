//
//  CharactersView.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 14.06.2022.
//

import SwiftUI

struct URLImage: View {
    let urlString: String
    
    @State var data: Data?
    
    var body: some View {
        
        if let data = data, let uiimage = UIImage(data: data) {
            Image(uiImage: uiimage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130, height: 130, alignment: .center)
                .background(Color.gray)
        } else {
          ProgressView()
            .onAppear {
                fetchData()
            }
        }
       
    }
    
    func fetchData() {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            self.data = data
        }

        task.resume()
    }
    
}

struct CharactersView: View {

    @State var searchText = ""
    @State var isSearching = false

    @ObservedObject var charViewModel :CharactersViewModel
    
    init(urlList: [String]? = nil, locationName: String? = nil) {
        charViewModel = CharactersViewModel(urlList: urlList, locationName: locationName)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15.0) {
                SearchBar(searchText: $searchText, isSearching: $isSearching)
                {
                    if self.charViewModel.urlList != nil {
                        self.charViewModel.nameFilter = self.searchText != "" ? self.searchText : nil
                    } else {
                        self.charViewModel.fetchDefaultList(nameFilter: self.searchText)
                    }
                }

                ForEach(charViewModel.nameFilter != nil ? charViewModel.characters.filter{$0.name.lowercased().contains(charViewModel.nameFilter!.lowercased())} :  charViewModel.characters, id: \.self) { character in
                    
                    VStack() {
                        URLImage(urlString: character.image)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                        Text(character.name)
                            .font(.largeTitle)
                        
                        Text("Gender: \(character.gender)")
                        
                        Text("Species: \(character.species)")
                        
                        Text("\(character.status)")
                    }
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.gray)
                            .shadow(color: .black, radius: 4, x: 0, y: 1))
                    .padding(5)
                    .onAppear {
                        if (character == charViewModel.characters.last){
                            charViewModel.loadNextPage()
                        }
                    }
                }
                if(charViewModel.isLoading)
                {
                    ProgressView()
                }
        
                
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
        .navigationBarTitle("Characters")
        .onAppear() {
            charViewModel.fetch()
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
