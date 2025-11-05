//
//  DebugLayout.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import SwiftUI

extension View {
    func debugSize() -> some View {
        self.overlay {
            GeometryReader { proxy in
                Text(
                    "\(proxy.size.width) x \(proxy.size.height)"
                )
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(4)
                    .background { Color.purple }
                    .fixedSize()
                    .frame(width: proxy.size.width,
                           height: proxy.size.height)
            }
        }
    }
}
