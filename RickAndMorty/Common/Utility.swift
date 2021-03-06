//
//  Utility.swift
//  RickAndMorty
//
//  Created by Enver Yigitler on 21.06.2022.
//

import Foundation
import SwiftUI

struct Utility {
    static func fetch<HandlerInput: Codable>(type: HandlerInput.Type ,url: URL, completionHandler: @escaping (HandlerInput) -> Void ){
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONDecoder().decode(type, from: data)
                DispatchQueue.main.async {
                   completionHandler(response)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
