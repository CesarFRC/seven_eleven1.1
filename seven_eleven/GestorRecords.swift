import Foundation

class GestorRecords {
    static let shared = GestorRecords()
    
    private let clave = "recordsGuardados"
    private let maxRecords = 10
    
    private init() {}
    
    struct Record: Codable {
        let nombre: String
        let puntuacion: Int
        let fecha: Date
    }
    
    func obtenerRecords() -> [Record] {
        guard let datos = UserDefaults.standard.data(forKey: clave),
              let records = try? JSONDecoder().decode([Record].self, from: datos) else {
            return []
        }
        return records.sorted { $0.puntuacion > $1.puntuacion }
    }
    
    func agregarRecord(nombre: String, puntuacion: Int) {
        var records = obtenerRecords()
        let nuevoRecord = Record(nombre: nombre, puntuacion: puntuacion, fecha: Date())
        records.append(nuevoRecord)
        
        records.sort { $0.puntuacion > $1.puntuacion }
        if records.count > maxRecords {
            records = Array(records.prefix(maxRecords))
        }
        
        guardarRecords(records)
    }
    
    private func guardarRecords(_ records: [Record]) {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: clave)
        }
    }
    
    func esTopRecord(puntuacion: Int) -> Bool {
        let records = obtenerRecords()
        if records.count < maxRecords {
            return true
        }
        return puntuacion > (records.last?.puntuacion ?? 0)
    }
}
