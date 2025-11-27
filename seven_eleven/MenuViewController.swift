import UIKit

class MenuViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicaViewController.shared.reproducirMusicaMenu()
    }
}
