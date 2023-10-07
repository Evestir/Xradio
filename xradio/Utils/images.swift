//
//  fetchImage.swift
//  xradio
//
//  Created by vesolis on 2023/10/06.
//

import Foundation
import SwiftUI

func loadImageFromPath(path: String) -> NSImage {
    let url = URL(fileURLWithPath: path)
    do {
        let data = try Data(contentsOf: url)
        if let image = NSImage(data: data) {
            return image
        } else {
            return NSImage(systemSymbolName: "questionmark.folder.fill", accessibilityDescription: nil)! // Return a default image or handle the error
        }
    } catch {
        return NSImage(systemSymbolName: "questionmark.folder.fill", accessibilityDescription: nil)! // Return a default image or handle the error
    }
}
