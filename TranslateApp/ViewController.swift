//
//  ViewController.swift
//  TranslateApp
//
//  Created by Katya Miranda on 28/10/23.
//

import UIKit

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
    
    
    // MARK: - ViewModel
    
    var translateViewModel: TranslateViewModel = TranslateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateViewModel.delegate = self
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
        let translateSymbol = translateViewModel.translateSymbol
        
        translateViewModel.translateSymbol = translateViewModel.translatedSymbol
        translateViewModel.translatedSymbol = translateSymbol
        
        imageCountryButton.setImage(imageCountryTranslatedButton.imageView?.image, for: .normal)
        translateTextView.text = translatedTextView.text
        
        imageCountryTranslatedButton.setImage(translateImage, for: .normal)
        translatedTextView.text = translateText
    }
    
    @IBAction func translateButton(_ sender: UIButton) {
        
        if let textToTranslate = translateTextView.text, !textToTranslate.isEmpty{
            translateViewModel.executeService(textToTranslate)
        }else {
            let alert = UIAlertController(title: "Falta información", message: "Escribe lo que deseas traducir", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
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
            translateViewModel.translateSymbol = symbol
        } else {
            imageCountryTranslatedButton.setImage(UIImage(named: image), for: .normal)
            translateViewModel.translatedSymbol = symbol
        }
    }
}

extension ViewController: TranslateDelegate {
    func get(translation: String) {
        translatedTextView.text = translation
    }
}
