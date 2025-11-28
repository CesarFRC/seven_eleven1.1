

import UIKit

class RecordsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    MusicaViewController.shared.reproducirMusicaMenu()
    cargarRecords()
    }
 
    
    @IBOutlet weak var tablaRecords: UITableView!
    
    
    
    @IBAction func BotonAtras(_ sender: Any) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        
        self.dismiss(animated: true) {
        }
    }
    
    var records: [GestorRecords.Record] = []

    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            tablaRecords.register(UITableViewCell.self, forCellReuseIdentifier: "celdaRecord")
            tablaRecords.dataSource = self
            tablaRecords.delegate = self
            tablaRecords.backgroundColor = .clear
            tablaRecords.separatorStyle = .none
            tablaRecords.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            inicializarRecordsPorDefecto()
            cargarRecords()
        }
        
        func inicializarRecordsPorDefecto() {
            let recordsGuardados = GestorRecords.shared.obtenerRecords()
            
            if recordsGuardados.isEmpty {
                GestorRecords.shared.agregarRecord(nombre: "Donlike", puntuacion: 30)
                GestorRecords.shared.agregarRecord(nombre: "Fer", puntuacion: 25)
                GestorRecords.shared.agregarRecord(nombre: "Sergio", puntuacion: 20)
                GestorRecords.shared.agregarRecord(nombre: "Frijolito", puntuacion: 15)
                GestorRecords.shared.agregarRecord(nombre: "Carlos", puntuacion: 10)
            }
        }
        
        func cargarRecords() {
            records = obtenerRecordsOrdenados()
            tablaRecords.reloadData()
        }
        
        func obtenerRecordsOrdenados() -> [GestorRecords.Record] {
            let todosLosRecords = GestorRecords.shared.obtenerRecords()
            return todosLosRecords.sorted { $0.puntuacion > $1.puntuacion }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return records.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaRecord", for: indexPath)
            
            let record = records[indexPath.row]
            
            celda.textLabel?.text = "\(record.nombre) - \(record.puntuacion) pts"
            celda.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            celda.textLabel?.textColor = .white
            celda.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1)
            celda.layer.cornerRadius = 10
            celda.clipsToBounds = true
            celda.selectionStyle = .none
            
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
