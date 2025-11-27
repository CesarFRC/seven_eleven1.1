import AVFoundation

class MusicaViewController{
        static let shared = MusicaViewController()
        var reproductorMenu: AVAudioPlayer?
        let nombrePistaMenu = "C418 - Subwoofer Lullaby - Minecraft Volume Alpha - SMORT"
        
        private init() { }
        
        func reproducirMusicaMenu() {
            if let player = reproductorMenu, player.isPlaying {
                return
            }
            guard let url = Bundle.main.url(forResource: nombrePistaMenu, withExtension: "mp3") else {
                print("No se encontró el archivo de audio del menú")
                return
            }
            do {
                reproductorMenu = try AVAudioPlayer(contentsOf: url)
                reproductorMenu?.numberOfLoops = -1
                reproductorMenu?.volume = 0.5
                reproductorMenu?.prepareToPlay()
                reproductorMenu?.play()
            } catch {
                print("Error al reproducir música del menú: \(error)")
            }
        }
        func detenerMusica() {
            reproductorMenu?.stop()
            reproductorMenu?.currentTime = 0
        }
}
