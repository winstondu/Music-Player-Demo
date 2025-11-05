//
//  ActionModifier.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import SwiftUI

struct ActionModifer: ViewModifier {
    let action: () -> ();
    
    func body(content: Content) -> some View {
        content
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    action()
                }
            )
    }
}

// Used since long-press is different from tap
extension View {
    func releaseAction(action: @escaping () -> ()) -> some View {
        return modifier(ActionModifer(action: action))
    }
}
