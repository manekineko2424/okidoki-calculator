//
//  PersistenceManager.swift
//  MyFirstApp
//

import Foundation

/// 永続化管理
enum PersistenceManager {
    private static let key = "okidoki_v15"

    /// 状態を保存
    static func save(_ state: AppState) {
        do {
            let data = try JSONEncoder().encode(state)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save state: \(error)")
        }
    }

    /// 状態を読み込み
    static func load() -> AppState? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(AppState.self, from: data)
        } catch {
            print("Failed to load state: \(error)")
            return nil
        }
    }

    /// 状態をリセット
    static func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
