//
//  MachineTabBar.swift
//  MyFirstApp
//

import SwiftUI

/// フッター機種タブバー
struct MachineTabBar: View {
    @Binding var selectedModel: MachineModel

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MachineModel.allCases, id: \.self) { model in
                MachineTabItem(
                    model: model,
                    isSelected: selectedModel == model
                ) {
                    selectedModel = model
                }
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Divider(),
            alignment: .top
        )
    }
}

/// 個別タブアイテム
struct MachineTabItem: View {
    let model: MachineModel
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .fill(isSelected ? model.themeColor : Color.clear)
                    .frame(width: 8, height: 8)

                Text(model.displayName)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundStyle(isSelected ? model.themeColor : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? model.themeColor.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}

/// 機種ごとのテーマカラー
extension MachineModel {
    var themeColor: Color {
        switch self {
        case .black: return .primary
        case .gold: return .orange
        case .gorgeous: return .purple
        case .custom: return .gray
        }
    }
}

#Preview {
    VStack {
        Spacer()
        MachineTabBar(selectedModel: .constant(.black))
    }
}
