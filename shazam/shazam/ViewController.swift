//
//  ViewController.swift
//  shazam
//
//  Created by Aurelio Le Clarke on 11.05.2022.
//

import UIKit
import ShazamKit


class ViewController: UIViewController, SHSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func recognizeSong() {
        let session = SHSession()
        session.delegate = self
        do {
            guard let url = Bundle.main.url(forResource: "G", withExtension: "mp3") else {
               print("couldnt find a song")
                return}
            let file = try AVAudioFile(forReading: url)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length / 10)
            ) else { return }
            try file.read(into: buffer)
            let generator = SHSignatureGenerator()
            try generator.append(buffer, at: nil)
            let singature = generator.signature()
            session.match(singature)
        }
        catch {
            print(error)
        }
    }

    func session(_ session: SHSession, didFind match: SHMatch) {
        let items = match.mediaItems
        items .forEach { item in
            print(item.title ?? "title")
            print(item.artist ?? "artist")
            print(item.artworkURL?.absoluteURL ?? " artwork url" )
        }
    }
    func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        if let error = error {
            print(error)
        }
    }
}

