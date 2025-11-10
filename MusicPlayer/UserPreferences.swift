//
//  UserPreferences.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/9/25.
//

import Foundation
import Combine

/// Protocol for managing user preferences, particularly track favoriting
protocol UserPreferencesProtocol {
    func isFavorite(trackId: String) -> Bool
    func setFavorite(_ isFavorite: Bool, for trackId: String)
}

/// Default implementation of UserPreferences
@MainActor
class UserPreferences: ObservableObject, UserPreferencesProtocol {
    static let shared = UserPreferences()

    @Published private var favorites: [String: Bool] = [:]

    private init() {}

    func isFavorite(trackId: String) -> Bool {
        return favorites[trackId] ?? false
    }

    func setFavorite(_ isFavorite: Bool, for trackId: String) {
        favorites[trackId] = isFavorite
    }
}
