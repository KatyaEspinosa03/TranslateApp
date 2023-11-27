//
//  TranslateViewModel.swift
//  TranslateApp
//
//  Created by Katya Miranda on 26/11/23.
//

import Foundation

protocol TranslateDelegate: AnyObject {
    func get(translation:String)
}

class TranslateViewModel {
    
    
    var translateSymbol = "en"
    var translatedSymbol = "es"
    
    weak var delegate: TranslateDelegate?
    
    // MARK: - Connection with web service.
    /// function to connect with a webservice using URLSessions
    
   private  let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2")!
    private  let urlSession = URLSession.shared
    
    public func executeService(_ textToTranslate: String) {
        
        let dataTask = urlSession.dataTask(with: getRequest(with: textToTranslate)) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }else if let response = response as? HTTPURLResponse, let data = data {
                self.mapData(data: data)
            }
        }
        dataTask.resume()
    }
    
    private func getHeaders() -> [String: String]{
        [
            "content-type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "4628b3ca27msh9c7282376d9f318p1ed571jsn71c004e33816",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
    }
    
    private func getData(with textToTranslate: String) -> Data? {
        
        let data = NSMutableData(data: "q=\(textToTranslate)".data(using: .utf8)!)
        data.append("&target=\(translatedSymbol)".data(using: .utf8)!)
        data.append("&source=\(translateSymbol)".data(using: .utf8)!)
        return data as Data
    }
    
    private func getRequest(with textToTranslate: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = getHeaders()
        request.httpBody = getData(with: textToTranslate)
        
        return request
    }
    
    private func mapData(data: Data) {
        do{
            let json = try JSONDecoder().decode(DataContainer.self, from: data)
            print(json)
            
            // se usa dispatchqueue para regresar al hilo principal.
            DispatchQueue.main.async {
                // usamos first! para obtener el primer elemento del arreglo
                self.delegate?.get(translation: json.data.translations.first!.translatedText)
            }
            print(json.data.translations.first!.translatedText)
            
        }catch{
            print(error.localizedDescription)
            
        }
    }
}

