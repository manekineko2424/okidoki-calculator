//
//  SettingsView.swift
//  MyFirstApp
//
//  設定画面（シート表示）
//

import SwiftUI

/// 設定画面
struct SettingsView: View {
    @Binding var limitG: String
    @Binding var rbAdd: String
    @Binding var bbAdd: String
    let isCustom: Bool
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                // 上限G設定（全機種共通）
                Section {
                    HStack {
                        Text("有利区間上限")
                        Spacer()
                        TextField("", text: $limitG)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("G")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("上限設定")
                } footer: {
                    Text("通常は変更不要です。ブラック・ゴールドは2000G、ゴージャスは3000Gが標準です。")
                }

                // カスタム機種の場合のみ内部加算設定を表示
                if isCustom {
                    Section {
                        HStack {
                            Text("RB内部加算")
                            Spacer()
                            TextField("", text: $rbAdd)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                            Text("G")
                                .foregroundStyle(.secondary)
                        }

                        HStack {
                            Text("BB内部加算")
                            Spacer()
                            TextField("", text: $bbAdd)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 60)
                            Text("G")
                                .foregroundStyle(.secondary)
                        }
                    } header: {
                        Text("カスタム設定")
                    } footer: {
                        Text("内部加算はボーナス終了時に加算されるゲーム数です。機種によって異なります。")
                    }
                }

                // プリセット情報（プリセット機種の場合）
                if !isCustom {
                    Section {
                        Text("プリセット機種では内部加算は自動設定されます。カスタム値を使用したい場合は「カスタム」機種を選択してください。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } header: {
                        Text("内部加算について")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        onClose()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview("プリセット機種") {
    SettingsView(
        limitG: .constant("2000"),
        rbAdd: .constant("24"),
        bbAdd: .constant("59"),
        isCustom: false,
        onClose: {}
    )
}

#Preview("カスタム機種") {
    SettingsView(
        limitG: .constant("2000"),
        rbAdd: .constant("24"),
        bbAdd: .constant("59"),
        isCustom: true,
        onClose: {}
    )
}
