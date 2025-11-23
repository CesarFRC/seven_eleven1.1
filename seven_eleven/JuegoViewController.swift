import UIKit

class JuegoViewController: UIViewController {

    @IBOutlet weak var botonTirar: UIButton!
    @IBOutlet weak var dadoIzquierdo: UIImageView!
    @IBOutlet weak var dadoDerecho: UIImageView!
    
    let nombresImagenesDados = ["dado1", "dado2", "dado3", "dado4", "dado5", "dado6"]
    
    
    
    
    
    @IBOutlet weak var etiquetaRonda: UILabel!
    
    
    @IBOutlet weak var etiquetaPuntos: UILabel!
    
    
    @IBOutlet weak var etiquetaTiempo: UILabel!
    
    
    @IBOutlet weak var etiquetaVidas: UILabel!
    
    
        var rondaActual = 1
        var vidasRestantes = 3
        var puntoObjetivo: Int?
    
        var gameTimer: Timer?
        var segundosTranscurridos: Int = 0
        var puntuacionTotal = 0
        var tirosEnRonda = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dadoIzquierdo.image = UIImage(named: "dado1")
        dadoDerecho.image = UIImage(named: "dado1")
        actualizarUI()
    }

    @IBAction func accionBotonAtras(_ remitente: UIButton) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        detenerTemporizador()
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func Tirar(_ sender: Any) {
        guard vidasRestantes > 0 else {
        mostrarAlerta(titulo: "Juego Terminado", mensaje: "¡Reinicia para jugar de nuevo!")
        return
                }
        
        tirosEnRonda += 1
        
        if gameTimer == nil {
        iniciarTemporizador()
                }
        
        botonTirar.isEnabled = false
        animarDados()
    }
    
    @objc func actualizarContador() {
            segundosTranscurridos += 1
            actualizarUI()
        }
    
    func iniciarTemporizador() {
        if gameTimer == nil {
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0,
        target: self,
        selector: #selector(actualizarContador),
        userInfo: nil,
        repeats: true)
            }
        }
    
  

        func detenerTemporizador() {
            gameTimer?.invalidate()
            gameTimer = nil
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
        print("Resultado de la tirada: \(dado1) y \(dado2). Total: \(sumaTotal). Ronda: \(rondaActual). Punto: \(puntoObjetivo ?? 0). Tiro: \(tirosEnRonda)")
            
        var mensajeAlerta = ""
        var tituloAlerta = ""
        var juegoContinua = true
        var rondaGanadaOPerdida = false

        if let punto = puntoObjetivo {
            
            switch sumaTotal {
            case punto:
                tituloAlerta = "¡Punto Ganado! "
                mensajeAlerta = "¡Sacaste el punto \(punto) y avanzas a la Ronda \(rondaActual + 1)!"
                rondaGanadaOPerdida = true
                
                if tirosEnRonda == 2 {
                    puntuacionTotal += 5
                    mensajeAlerta += " Ganas 5 puntos."
                }

                rondaActual += 1
                puntoObjetivo = nil
                
            case 7, 11, 2, 12:
                vidasRestantes -= 1
                tituloAlerta = "¡Punto Perdido! "
                mensajeAlerta = "Salió \(sumaTotal). Pierdes una vida. ¡El punto se reinicia!"
                rondaGanadaOPerdida = true
                puntoObjetivo = nil
                
            default:
                tituloAlerta = "Sigue Tirando"
                mensajeAlerta = "El punto objetivo sigue siendo: **\(punto)**. ¡Vuelve a intentarlo!"
                juegoContinua = true
            }
        }
        else {
            switch sumaTotal {
            case 7, 11:
                puntuacionTotal += 10
                rondaGanadaOPerdida = true
                tituloAlerta = "¡Ronda Ganada a la 1ra! "
                mensajeAlerta = "Suma: \(sumaTotal). ¡Ganas 10 puntos y pasas a la Ronda \(rondaActual + 1)!"
                rondaActual += 1
                
            case 2, 12:
                vidasRestantes -= 1
                tituloAlerta = "Vida Perdida "
                mensajeAlerta = "Salió \(sumaTotal). Pierdes una vida."
                rondaGanadaOPerdida = true
                
            default:
                puntoObjetivo = sumaTotal
                tituloAlerta = "Punto Establecido"
                mensajeAlerta = "El punto es **\(sumaTotal)**. Ahora debes sacar \(sumaTotal) de nuevo ANTES de sacar 7, 11, 2 o 12."
            }
        }
            
        if rondaGanadaOPerdida {
            tirosEnRonda = 0
        }
            
        if vidasRestantes <= 0 {
            tituloAlerta = "Fin del Juego "
            mensajeAlerta = "¡Te has quedado sin vidas! Finalizaste en la Ronda \(rondaActual). Puntuación Final: \(puntuacionTotal)"
            juegoContinua = false
            detenerTemporizador()
        }
            
        actualizarUI()

        if juegoContinua || vidasRestantes <= 0 {
            mostrarAlerta(titulo: tituloAlerta, mensaje: mensajeAlerta)
        }
    }
    func actualizarUI() {
        etiquetaVidas.text = "\(vidasRestantes)"
        etiquetaRonda.text = "Ronda: \(rondaActual)"
        etiquetaPuntos.text = "Puntuacion: \(puntuacionTotal)"


        let minutos = segundosTranscurridos / 60
        let segundos = segundosTranscurridos % 60
        etiquetaTiempo.text = String(format: "%02d:%02d", minutos, segundos)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        self.present(alerta, animated: true)
            }
        
}

