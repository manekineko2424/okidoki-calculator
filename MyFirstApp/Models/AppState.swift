//
//  AppState.swift
//  MyFirstApp
//

import Foundation

/// 機種ごとの状態
struct MachineState: Codable {
    var rbAdd: String
    var bbAdd: String
    var limitG: String
    var rows: [Row]
    var resetIndex: Int
    var cutIndex: Int?

    /// 機種プリセットから初期状態を生成
    static func initial(for model: MachineModel) -> MachineState {
        let preset = model.preset
        let rows = Row.initialRows()
        return MachineState(
            rbAdd: preset.rbAdd,
            bbAdd: preset.bbAdd,
            limitG: preset.limitG,
            rows: rows,
            resetIndex: rows.count,
            cutIndex: nil
        )
    }
}

/// アプリ全体の状態
struct AppState: Codable {
    var currentModel: MachineModel
    var machineStates: [MachineModel: MachineState]

    /// 現在の機種の状態を取得/設定
    var currentState: MachineState {
        get {
            machineStates[currentModel] ?? MachineState.initial(for: currentModel)
        }
        set {
            machineStates[currentModel] = newValue
        }
    }

    /// 初期状態を生成
    static func initial() -> AppState {
        var states: [MachineModel: MachineState] = [:]
        for model in MachineModel.allCases {
            states[model] = MachineState.initial(for: model)
        }
        return AppState(
            currentModel: .black,
            machineStates: states
        )
    }
}

// MARK: - Codable拡張（Dictionary<MachineModel, MachineState>対応）

extension AppState {
    enum CodingKeys: String, CodingKey {
        case currentModel
        case machineStates
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        currentModel = try container.decode(MachineModel.self, forKey: .currentModel)

        // Dictionary<String, MachineState>としてデコードしてからMachineModelに変換
        let stringKeyedStates = try container.decode([String: MachineState].self, forKey: .machineStates)
        var states: [MachineModel: MachineState] = [:]
        for (key, value) in stringKeyedStates {
            if let model = MachineModel(rawValue: key) {
                states[model] = value
            }
        }
        machineStates = states
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(currentModel, forKey: .currentModel)

        // MachineModelをStringに変換してエンコード
        var stringKeyedStates: [String: MachineState] = [:]
        for (key, value) in machineStates {
            stringKeyedStates[key.rawValue] = value
        }
        try container.encode(stringKeyedStates, forKey: .machineStates)
    }
}
