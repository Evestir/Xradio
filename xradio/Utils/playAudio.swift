//
//  playAudio.swift
//  xradio
//
//  Created by vesolis on 2023/10/06.
//

import Foundation
import AVFoundation

var player = AVPlayer()

func playFromUrl(url:String) {
    if let url = URL(string: url) {
        player = AVPlayer(url: url)
        player.play()
    }
}
