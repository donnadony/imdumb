//
//  FirebaseDataSource.swift
//  IMDUMB
//
//  Created by Donnadony Mollo on 7/05/26.
//

import FirebaseCore
import FirebaseRemoteConfig

protocol ConfigDataSourceProtocol {

    func fetchConfig(completion: @escaping (Result<AppConfig, Error>) -> Void)

}

final class FirebaseDataSource: ConfigDataSourceProtocol {

    // MARK: - Properties

    private var remoteConfig: RemoteConfig?

    // MARK: - Lifecycle

    init() {
        guard FirebaseApp.app() != nil else { return }
        let config = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEV
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 3600
        #endif
        config.configSettings = settings
        config.setDefaults([
            "show_recommendations": NSNumber(value: true),
            "app_version": NSString(string: "1.0"),
            "welcome_message": NSString(string: "Bienvenido a IMDUMB"),
            "environment": NSString(string: "dev")
        ])
        self.remoteConfig = config
    }

    func fetchConfig(completion: @escaping (Result<AppConfig, Error>) -> Void) {
        guard let remoteConfig else {
            completion(.success(buildDefaultConfig()))
            return
        }
        remoteConfig.fetch { [weak self] status, _ in
            guard let self, let remoteConfig = self.remoteConfig else { return }
            guard status == .success else {
                completion(.success(self.buildDefaultConfig()))
                return
            }
            remoteConfig.activate { _, _ in
                let config = AppConfig(
                    showRecommendations: remoteConfig["show_recommendations"].boolValue,
                    appVersion: remoteConfig["app_version"].stringValue,
                    welcomeMessage: remoteConfig["welcome_message"].stringValue,
                    environment: remoteConfig["environment"].stringValue
                )
                completion(.success(config))
            }
        }
    }

    private func buildDefaultConfig() -> AppConfig {
        AppConfig(
            showRecommendations: true,
            appVersion: "1.0",
            welcomeMessage: "Bienvenido a IMDUMB",
            environment: "dev"
        )
    }
}
