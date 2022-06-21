//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 13.06.2022.
//

import SwiftUI

struct MainView: View {
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                Image("logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 100, alignment: .center)
                    .padding(5)
                    .background(Color.black.cornerRadius(30))
                
                NavigationLink(destination: LocationsView(), tag: 1, selection: $selection) {
                    MainViewButton(title: "Locations", imageName: "locations") {
                        selection = 1
                    }
                }
                
                NavigationLink(destination: CharactersView(), tag: 2, selection: $selection) {
                    MainViewButton(title: "Characters", imageName: "characters") {
                        selection = 2
                    }
                }
                NavigationLink(destination: EpisodesView(), tag: 3, selection: $selection) {
                    MainViewButton(title: "Episodes", imageName: "episodes") {
                        selection = 3
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(
                                colors: [.green, .yellow]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            )
        }
        
    }
    
    
    struct MainViewButton: View {
        var title: String
        var imageName: String
        var action: () -> Void
        
        var body: some View {
            Button(action: action, label: {
                ZStack(alignment: .top) {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 180, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(2)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.black)
                                        .opacity(0.5))
                        .padding(5)
                    
                    
                }
            }).shadow(color: .black, radius: 4, x: 0, y: 1)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
