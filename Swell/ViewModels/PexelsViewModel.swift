//
//  PexelsViewModel.swift
//  Swell
//
//  Created by Tanner Maasen on 1/27/22.
//

import Foundation

class PexelsViewModel: ObservableObject {
    let cache = NSCache<NSString, Pexel>()
    let API_URL:URL! = URL(string: "https://api.pexels.com/v1/search?query=landscape&page=1&per_page=20&size=small&orientation=landscape")
    @Published var pexel = Photo()
    @Published var isLoadingPexel: Bool = false
    
    init() {
        self.isLoadingPexel = true
        getPexel() { pexels in
            self.pexel = (pexels?.photos?.randomElement())!
            self.isLoadingPexel = false
        }
    }
    
    func getPexel(completion: @escaping (Pexel?) -> ()) {
        guard let apiKey = Bundle.main.infoDictionary?["PEXELS_API_KEY"] as? String else {return}

        if let image = cache.object(forKey: "image") {
            completion(image)
        }
         
        var urlRequest = URLRequest(url: API_URL)
        // Setting HTTP Headers
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            do {
                let pexels = try JSONDecoder().decode(Pexel.self, from: data ?? Data())
                DispatchQueue.main.async {
                    self.cache.setObject(pexels, forKey: "image")
                    completion(pexels)
                }
            } catch {
                print("JSONSerialization error:", error)
                completion(nil)
                return
            }
        }
        .resume()
    }
    
}
