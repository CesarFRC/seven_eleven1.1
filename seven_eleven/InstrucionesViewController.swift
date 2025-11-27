import UIKit

class InstrucionesViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        MusicaViewController.shared.reproducirMusicaMenu()
        }

  
    @IBAction func BotonAtras(_ sender: Any) {
        cerrarVistaModal()
    }
    
    func cerrarVistaModal() {
        self.dismiss(animated: true) {
        }
    }
}
