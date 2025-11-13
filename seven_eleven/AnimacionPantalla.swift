import UIKit

class AnimacionPantalla: UIViewController {
    
    @IBOutlet weak var imagenLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iniciarAnimacion()
    }
    
    private func iniciarAnimacion() {
        
        imagenLogo.alpha = 0.0
        imagenLogo.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            .translatedBy(x: 0, y: 60)
        
        UIView.animate(withDuration: 7,
                       delay: 0.1,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut) {
            
            self.imagenLogo.alpha = 1.0
            self.imagenLogo.transform = .identity
            
        } completion: { _ in
            self.animacionSalida()
        }
    }

    private func animacionSalida() {
        UIView.animate(withDuration: 6,
                       delay: 2.5,
                       options: [.curveEaseInOut]) {
            
            self.imagenLogo.alpha = 0.0
            self.imagenLogo.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
                .translatedBy(x: 0, y: -250)
            
        } completion: { _ in
            self.cambiarPantallaPrincipal()
        }
    }
    
    private func cambiarPantallaPrincipal() {
     
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
       
        
        let siguienteControlador = mainStoryboard.instantiateViewController(withIdentifier: "Menu")
            siguienteControlador.modalPresentationStyle = .fullScreen
            self.present(siguienteControlador, animated: true, completion: nil)
    }
}
