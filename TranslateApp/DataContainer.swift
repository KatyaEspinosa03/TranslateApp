//
//  DataContainer.swift
//  TranslateApp
//
//  Created by Katya Miranda on 26/11/23.
//

import Foundation
struct DataContainer: Decodable{
    let data: TranslationsData
    
    struct TranslationsData: Decodable {
        let translations: [Translation]
        
        struct Translation: Decodable {
            let translatedText: String
        }
    }
}
