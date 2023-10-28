//
//  ViewController.swift
//  TranslateApp
//
//  Created by Katya Miranda on 28/10/23.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageCountryButton: UIButton!
    @IBOutlet weak var imageCountryTranslatedButton: UIButton!
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .systemGreen
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        imageCountryButton.layer.cornerRadius = 15
        imageCountryButton.layer.borderWidth = 2
        imageCountryButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        imageCountryTranslatedButton.layer.cornerRadius = 15
        imageCountryTranslatedButton.layer.borderWidth = 2
        imageCountryTranslatedButton.layer.borderColor = UIColor.systemGreen.cgColor
    
        
        // Do any additional setup after loading the view.
    }
    @IBAction func selectCountryTranslateButton(_ sender: UIButton) {
    }
    
    @IBAction func selectCountryTranslatedButton(_ sender: UIButton) {
    }
    
    @IBAction func changeTranslationButton(_ sender: Any) {
    }
    
    @IBAction func translateButton(_ sender: UIButton) {
        
        if let textToTranslate = translateTextView.text, !textToTranslate.isEmpty{
            getTranslatation(with: textToTranslate)
        }else {
            let alert = UIAlertController(title: "Falta información", message: "Escribe lo que deseas traducir", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    // MARK: - Connection with web service.
    /// function to connect with a webservice using URLSessions
    func getTranslatation(with text: String) {
        print("estoy en la funcion getTranslation")
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
                "Accept-Encoding": "application/gzip",
                "X-RapidAPI-Key": "4628b3ca27msh9c7282376d9f318p1ed571jsn71c004e33816",
                "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2")!
        
        let data = NSMutableData(data: "q=\(text)".data(using: .utf8)!)
        data.append("&target=es".data(using: .utf8)!)
        data.append("&source=en".data(using: .utf8)!)
        

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        //obtener instancia de URLSession
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
            }else if let response = response as? HTTPURLResponse, let data = data {
                do{
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    print(json!)
                    
                }catch{
                    print(error.localizedDescription)
                    
                }
            }
        }
        dataTask.resume()
    }
    
}

