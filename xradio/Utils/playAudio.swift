//
//  playAudio.swift
//  xradio
//
//  Created by vesolis on 2023/10/06.
//

import Foundation
import AVFoundation

var player = AVPlayer()
var curUrl:String = ""

func playFromUrl(uri:String) {
    if let url = URL(string: uri) {
        player = AVPlayer(url: url)
        player.play()
    }
}
