

import UIKit

class RecordsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MusicaViewController.shared.reproducirMusicaMenu()
    }
 
    
    @IBOutlet weak var tablaRecords: UITableView!
    
    
    
    @IBAction func BotonAtras(_ sender: Any) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        
        self.dismiss(animated: true) {
        }
    }
    
    var records: [String] = [
        "Donlike - 45 puntuacion",
        "Fer - 40 puntuacion",
        "Sergio - 30 puntuacion",
        "Frijolito - 25 puntuacion",
        "Carlos - 20 puntuacion"
    ]
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
            tablaRecords.register(UITableViewCell.self, forCellReuseIdentifier: "celdaRecord")

            tablaRecords.dataSource = self
            tablaRecords.delegate = self
        
            tablaRecords.backgroundColor = .clear
            tablaRecords.separatorStyle = .none
            tablaRecords.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return records.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaRecord", for: indexPath)
            
            let componentes = records[indexPath.row].components(separatedBy: " - ")
            let nombre = componentes.first ?? ""
            let puntuacion = componentes.last ?? ""
            
            let posicion = indexPath.row + 1
            var emoji = ""
            switch posicion {
            case 1: emoji = "🥇 "
            case 2: emoji = "🥈 "
            case 3: emoji = "🥉 "
            default: emoji = "\(posicion). "
            }
            
            celda.textLabel?.text = "\(emoji)\(nombre) - \(puntuacion)"
            celda.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            celda.textLabel?.textColor = .white
            
            celda.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1)
            
            celda.layer.cornerRadius = 10
            celda.clipsToBounds = true
            
            if indexPath.row < 3 {
                celda.layer.borderWidth = 1
                switch indexPath.row {
                case 0: celda.layer.borderColor = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 0.5).cgColor
                case 1: celda.layer.borderColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.5).cgColor
                case 2: celda.layer.borderColor = UIColor(red: 0.80, green: 0.50, blue: 0.20, alpha: 0.5).cgColor
                default: break
                }
            } else {
                celda.layer.borderWidth = 0
            }
            
            return celda
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
}
