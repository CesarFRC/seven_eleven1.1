import UIKit
import AVFoundation

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
    
    
    var reproductorMusica: AVAudioPlayer?
    var reproductorEfectos: AVAudioPlayer?
    
    let pistaJuego = "Minecraft Volume Alpha - 14 - Clark - C418"
    let sonidoDado = "tiro_de_dados"
    let sonidoPerderVida = "Muerte"
        
    var indicePistaActual = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dadoIzquierdo.image = UIImage(named: "dado1")
        dadoDerecho.image = UIImage(named: "dado1")
        actualizarUI()
        iniciarMusicaDeFondo()
    }

    @IBAction func accionBotonAtras(_ remitente: UIButton) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        detenerTemporizador()
        detenerMusica()
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func Tirar(_ sender: Any) {
        if vidasRestantes <= 0 {
                    reiniciarJuego()
                    return
                }
        
        reproducirSonido(nombre: sonidoDado)
        
        tirosEnRonda += 1
        
        if gameTimer == nil {
        iniciarTemporizador()
                }
        
        botonTirar.isEnabled = false
        animarDados()
    }
    
    
    func reiniciarJuego() {
            rondaActual = 1
            vidasRestantes = 3
            puntoObjetivo = nil
            segundosTranscurridos = 0
            puntuacionTotal = 0
            tirosEnRonda = 0
        
            detenerTemporizador()
            detenerMusica()
            iniciarMusicaDeFondo()
            
            detenerTemporizador()
            
            dadoIzquierdo.image = UIImage(named: "dado1")
            dadoDerecho.image = UIImage(named: "dado1")
            
            actualizarUI()
            
        }
    
    
        func reproducirSonido(nombre: String) {
            guard let url = Bundle.main.url(forResource: nombre, withExtension: "mp3") else {
                print("Error: No se pudo encontrar el archivo de sonido \(nombre).mp3")
                return
            }
            
            do {
                reproductorEfectos = try AVAudioPlayer(contentsOf: url)
                reproductorEfectos?.play()
            } catch {
                print("Error al inicializar el reproductor de efectos: \(error.localizedDescription)")
            }
        }
        
        func iniciarMusicaDeFondo() {
            guard let url = Bundle.main.url(forResource: pistaJuego, withExtension: "mp3") else {
                print("Error: No se pudo encontrar el archivo \(pistaJuego).mp3")
                return
            }
            
            do {
                reproductorMusica = try AVAudioPlayer(contentsOf: url)
                reproductorMusica?.numberOfLoops = -1
                reproductorMusica?.play()
                print("Reproduciendo: \(pistaJuego) en loop.")
            } catch {
                print("Error al inicializar el reproductor de música: \(error.localizedDescription)")
            }
        }
        
        func detenerMusica() {
            reproductorMusica?.stop()
            reproductorMusica = nil
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
        var rondaGanadaOPerdida = false
        var vidaPerdida = false

        if let punto = puntoObjetivo {
            
            switch sumaTotal {
            case punto:
                rondaGanadaOPerdida = true
                
                if tirosEnRonda == 2 {
                    puntuacionTotal += 5
                }

                rondaActual += 1
                puntoObjetivo = nil
                
            case 7, 11, 2, 12:
                vidasRestantes -= 1
                rondaGanadaOPerdida = true
                puntoObjetivo = nil
                vidaPerdida = true
                
            default:
                break
            }
        }
        else {
            switch sumaTotal {
            case 7, 11:
                puntuacionTotal += 10
                rondaGanadaOPerdida = true
                rondaActual += 1
                
            case 2, 12:
                vidasRestantes -= 1
                rondaGanadaOPerdida = true
                vidaPerdida = true
                
            default:
                puntoObjetivo = sumaTotal
            }
        }
            
        if rondaGanadaOPerdida {
            tirosEnRonda = 0
        }
        
        if vidaPerdida {
                    if vidasRestantes <= 0 {
                        detenerMusica()
                        reproducirSonido(nombre: sonidoPerderVida)
                    } else {
                        reproducirSonido(nombre: sonidoPerderVida)
                    }
                }
            
        if vidasRestantes <= 0 {
            tituloAlerta = "Fin del Juego "
            mensajeAlerta = "¡Te has quedado sin vidas! Finalizaste en la Ronda \(rondaActual). Puntuación Final: \(puntuacionTotal)"
            detenerTemporizador()
        }
            
        actualizarUI()

        if  vidasRestantes <= 0 {
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

