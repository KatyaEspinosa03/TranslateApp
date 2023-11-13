//
//  ViewController.swift
//  TranslateApp
//
//  Created by Katya Miranda on 28/10/23.
//

import UIKit

struct DataContainer: Decodable{
    let data: TranslationsData
    
    struct TranslationsData: Decodable {
        let translations: [Translation]
        
        struct Translation: Decodable {
            let translatedText: String
        }
    }
}

class ViewController: UIViewController {
    // MARK: - IBOutlets
    var translatedTexts: [DataContainer] = []
    @IBOutlet weak var imageCountryButton: UIButton!
    @IBOutlet weak var imageCountryTranslatedButton: UIButton!
    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    
    var translateImage: UIImage?
    var translateText = ""
    
    // Al mandarla a llamar regresa lo que el textView tenga
    var translatedText = ""
    var translatedImage:UIImage?
    
    var translateSymbol = ""
    var translatedSymbol = "es"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAtributes()
        
        translateImage = imageCountryButton.imageView?.image
        translateText = translateTextView.text
        
        translatedText = translatedTextView.text
        translatedImage = imageCountryTranslatedButton.imageView?.image
        
    
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        translateTextView.text = ""
        translatedTextView.text = ""
    }
    
    @IBAction func selectCountryTranslateButton(_ sender: UIButton) {
        performSegue(withIdentifier: "selectLanguage", sender: "CountryTranslate")
    }
    
    @IBAction func selectCountryTranslatedButton(_ sender: UIButton) {
        performSegue(withIdentifier: "selectLanguage", sender: "CountryTranslated")
    }
    
    @IBAction func changeTranslationButton(_ sender: Any) {
        let translateImage = imageCountryButton.imageView?.image
        let translateText = translateTextView.text
        let translateSymbol = self.translateSymbol
        
        self.translateSymbol = self.translatedSymbol
        self.translatedSymbol = translateSymbol
        
        imageCountryButton.setImage(imageCountryTranslatedButton.imageView?.image, for: .normal)
        translateTextView.text = translatedTextView.text
        
        imageCountryTranslatedButton.setImage(translateImage, for: .normal)
        translatedTextView.text = translateText
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
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "4628b3ca27msh9c7282376d9f318p1ed571jsn71c004e33816",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2")!
        
        let data = NSMutableData(data: "q=\(text)".data(using: .utf8)!)
        data.append("&target=\(translatedSymbol)".data(using: .utf8)!)
        data.append("&source=\(translateSymbol)".data(using: .utf8)!)
        
        
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
                    let json = try JSONDecoder().decode(DataContainer.self, from: data)
                    print(json)
                    
                    // se usa dispatchqueue para regresar al hilo principal.
                    DispatchQueue.main.async {
                        // usamos first! para obtener el primer elemento del arreglo
                        self.translatedTextView.text = json.data.translations.first!.translatedText
                    }
                  
                    print(json.data.translations.first!.translatedText)
                    
                }catch{
                    print(error.localizedDescription)
                    
                }
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Setting viewDidLoad attributes
    ///Function to set the physical properties of the elements when the app first loads.
    
    func setAtributes(){
        navigationController?.navigationBar.backgroundColor = .systemGreen
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        imageCountryButton.layer.cornerRadius = 15
        imageCountryButton.layer.borderWidth = 2
        imageCountryButton.layer.borderColor = UIColor.systemGreen.cgColor
        
        imageCountryTranslatedButton.layer.cornerRadius = 15
        imageCountryTranslatedButton.layer.borderWidth = 2
        imageCountryTranslatedButton.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let view = segue.destination as? LanguagesTableViewController {
            // 4. Decirle al delegate que nosotros recibiremos su funcion
            view.delegate = self
            view.type = sender as! String
        }
    }
    
}

// 5. heredar del delegado
extension ViewController: SelectLanguageDelegate {
    
    // 6. instanciar funciones del delegado
    func languageSelected(symbol: String, image: String, type: String) {
        // 7. usar valores que el delegado trae
        print(type)
        if type == "CountryTranslate" {
            imageCountryButton.setImage(UIImage(named: image), for: .normal)
            translateSymbol = symbol
        } else {
            imageCountryTranslatedButton.setImage(UIImage(named: image), for: .normal)
            translatedSymbol = symbol
        }
    }
    
    
}
