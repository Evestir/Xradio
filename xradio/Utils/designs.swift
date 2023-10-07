//
//  blurBG.swift
//  xradio
//
//  Created by vesolis on 2023/10/07.
//

import Foundation
import SwiftUI

extension View {
    func musicBox() -> some View {
        self
            .frame(width: 300, height: 300)
            .background(.ultraThinMaterial)
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(1), radius: 10.0)
    }
}
