//
//  PexelsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/27/22.
//

import Foundation

class PexelsViewModel: ObservableObject {
    let url:URL! = URL(string: "https://api.pexels.com/v1/search/Nature?page=1&per_page=1&size=small&orientation=landscape")
//    @Published var pexel = Pexels()
    
    // test function
//    func fetchBooks()
//    {
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: Pexels.self, decoder: JSONDecoder())
//            .replaceError(with:)
//            .eraseToAnyPublisher()
//            .receive(on: DispatchQueue.main)
//            .assign(to: &$pexel)
//    }
    
    // Gets one nature picture from Pexels
//    func getPexel() {
//        guard let apiKey = Bundle.main.infoDictionary?["PEXELS_API_KEY"] as? String else {return}
//
//        var urlRequest = URLRequest(url: url)
//        // Setting HTTP Headers
//        urlRequest.httpMethod = "GET"
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue(apiKey, forHTTPHeaderField: "Authorization")
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//            // Where the magic happens
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let imageURL:PexelImage = try JSONDecoder().decode(PexelImage.self, from: data)
//                        print("data: ", data)
//                        print("Pexel url: ", imageURL.url)
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//        dataTask.resume()
//    }
}
