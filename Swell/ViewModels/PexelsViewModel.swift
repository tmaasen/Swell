//
//  PexelsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/27/22.
//

import Foundation

class PexelsViewModel: ObservableObject {
    let API_URL:URL! = URL(string: "https://api.pexels.com/v1/search?query=nature?page=1&per_page=1&size=small&orientation=landscape")
    @Published var pexel = Pexel()
    
    // Gets one nature picture from Pexels
    func getPexel() {
        guard let apiKey = Bundle.main.infoDictionary?["PEXELS_API_KEY"] as? String else {return}

        var urlRequest = URLRequest(url: API_URL)
        // Setting HTTP Headers
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "Authorization")

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Error: ", error.localizedDescription)
                return
            }
            // no error
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    self.pexel = try JSONDecoder().decode(Pexel.self, from: data)
                } catch let error {
                    print("Error decoding: ", error.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
}
