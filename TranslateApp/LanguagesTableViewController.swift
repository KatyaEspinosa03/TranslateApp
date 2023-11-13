//
//  LanguagesTableViewController.swift
//  TranslateApp
//
//  Created by Katya Miranda on 05/11/23.
//

import UIKit

struct Languages {
    var language: String
    var languageImage: String
    var languageSymbol: String
}

struct LanguagesContainer: Decodable{
    let data: LanguagesData
    
    struct LanguagesData: Decodable {
        let languages: [Language]
        
        struct Language: Decodable {
            let language: String
        }
    }
}

// Patron de diseño delegates
// 1. Crear protocolo con la funcion
// El protocolo no guarda logica.
protocol SelectLanguageDelegate: AnyObject{
    func languageSelected(symbol: String, image: String, type: String)
}

class LanguagesTableViewController: UITableViewController {
    
    //2. crear variable del delegado en la clase en donde se ejecuta la función
    weak var delegate: SelectLanguageDelegate?
    
    var languagesData: [LanguagesContainer.LanguagesData.Language] = []
    
    var type: String = ""
    
    var languages: [Languages] = [
        .init(language: "Inglés", languageImage: "reino-unido", languageSymbol: "en"),
        .init(language: "Español", languageImage: "mexico", languageSymbol: "es"),
        .init(language: "Alemania", languageImage: "alemania", languageSymbol: "ger"),
        .init(language: "Francés", languageImage: "francia", languageSymbol: "fr"),
        .init(language: "Portugés", languageImage: "portugal", languageSymbol: "por")
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLanguages()
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return languages.count
        }else {
            return languagesData.count
        }
       
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "languageCellIdentifier", for: indexPath) as? LanguageTableViewCell
        
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "secondLanguageCellIdentifier", for: indexPath) as? SecondTableViewCell
        
        if indexPath.section == 0 {

            let language = languages[indexPath.row]
            cell1?.languageLabel.text = language.language
            cell1?.languageImageView.image = UIImage(named: language.languageImage)!
            return cell1 ?? UITableViewCell()
        } else {
            let language = languagesData[indexPath.row]
            cell2?.secondLanguageLabel.text = language.language
            return cell2 ?? UITableViewCell()
        }
        
        
      
      
        // Si no existe celda retorna una cell en blanco
        
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //3. ejecutar la función del delegado
        let language = languages[indexPath.row]
        delegate?.languageSelected(symbol: language.languageSymbol, image: language.languageImage, type: type)
        dismiss(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Web service connection
    
    func getLanguages() {
        
        print("Estoy en la funcion de getlanguages")
        
        let headers = [
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "4628b3ca27msh9c7282376d9f318p1ed571jsn71c004e33816",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        guard let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2/languages") else {return}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }else if let response = response as? HTTPURLResponse,
                     response.statusCode == 200, let data = data {
                do {
                    let json = try JSONDecoder().decode(LanguagesContainer.self, from: data)
                    self.languagesData = json.data.languages
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("data:", self.languagesData)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        dataTask.resume()
                            
    }
}
