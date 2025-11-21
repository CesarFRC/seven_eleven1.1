import UIKit

class JuegoViewController: UIViewController {

    @IBOutlet weak var botonTirar: UIButton!
    @IBOutlet weak var dadoIzquierdo: UIImageView!
    @IBOutlet weak var dadoDerecho: UIImageView!
    
    let nombresImagenesDados = ["dado1", "dado2", "dado3", "dado4", "dado5", "dado6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dadoIzquierdo.image = UIImage(named: "dado1")
        dadoDerecho.image = UIImage(named: "dado1")
    }

    @IBAction func accionBotonAtras(_ remitente: UIButton) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func Tirar(_ sender: Any) {
        botonTirar.isEnabled = false
   
        animarDados()
    }
    
    func animarDados() {

        let duracionAnimacion: TimeInterval = 0.5
        let tiempoRetardo: TimeInterval = duracionAnimacion

        let imagenesAnimacion: [UIImage] = nombresImagenesDados.compactMap { UIImage(named: $0) }
        
        if imagenesAnimacion.isEmpty {
             print("Error: No se encontraron las imágenes de los dados (dado1 a dado6).")
             self.botonTirar.isEnabled = true
             return
        }

        let resultadoIzquierdo = Int.random(in: 1...6)
        let resultadoDerecho = Int.random(in: 1...6)
        
        dadoIzquierdo.animationImages = imagenesAnimacion
        dadoIzquierdo.animationDuration = duracionAnimacion
        dadoIzquierdo.animationRepeatCount = 1
        dadoIzquierdo.startAnimating()

     
        dadoDerecho.animationImages = imagenesAnimacion.reversed()
        dadoDerecho.animationDuration = duracionAnimacion
        dadoDerecho.animationRepeatCount = 1
        dadoDerecho.startAnimating()

       
        DispatchQueue.main.asyncAfter(deadline: .now() + tiempoRetardo) {
            self.dadoIzquierdo.stopAnimating()
            self.dadoDerecho.stopAnimating()
           
            self.dadoIzquierdo.image = UIImage(named: self.nombresImagenesDados[resultadoIzquierdo - 1])
            self.dadoDerecho.image = UIImage(named: self.nombresImagenesDados[resultadoDerecho - 1])
            
            self.botonTirar.isEnabled = true
         
            self.procesarResultado(dado1: resultadoIzquierdo, dado2: resultadoDerecho)
        }
    }
    
    func procesarResultado(dado1: Int, dado2: Int) {
        let sumaTotal = dado1 + dado2
        print("Resultado de la tirada: \(dado1) y \(dado2). Total: \(sumaTotal)")
    }
}

