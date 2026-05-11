//
//  UserDefaultsWrapper.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//


import Foundation

@propertyWrapper
struct UserDefault<T> {

    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
}

struct AppSettings {

    @UserDefault(key: "has_seen_splash", defaultValue: false)
    static var hasSeenSplash: Bool

    @UserDefault(key: "show_recommendations", defaultValue: true)
    static var showRecommendations: Bool

    @UserDefault(key: "app_version", defaultValue: "1.0")
    static var appVersion: String

    @UserDefault(key: "welcome_message", defaultValue: "Bienvenido a IMDUMB")
    static var welcomeMessage: String

    @UserDefault(key: "environment", defaultValue: "dev")
    static var environment: String

    @UserDefault(key: "has_seen_onboarding", defaultValue: false)
    static var hasSeenOnboarding: Bool
}
