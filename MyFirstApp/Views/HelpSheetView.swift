//
//  HelpSheetView.swift
//  MyFirstApp
//
//  ヘルプシート（ジャンル分けアコーディオン形式）
//

import SwiftUI

/// Apple設定画面風アイコンバッジ
struct IconBadgeView: View {
    let systemName: String
    let backgroundColor: Color
    let size: CGFloat

    init(systemName: String, backgroundColor: Color, size: CGFloat = 28) {
        self.systemName = systemName
        self.backgroundColor = backgroundColor
        self.size = size
    }

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

/// ヘルプシート
struct HelpSheetView: View {
    @Environment(\.dismiss) private var dismiss

    // 各セクションの開閉状態
    @State private var isRecommendedExpanded = false
    @State private var isModeToggleExpanded = false
    @State private var isCurrentEditExpanded = false
    @State private var isHistoryModeExpanded = false
    @State private var isRealtimeModeExpanded = false

    private let rowLeadingInset: CGFloat = 16
    private let rowTrailingInset: CGFloat = 16
    private let rowVerticalInset: CGFloat = 8
    private let labelTextLeadingOffset: CGFloat = 28

    var body: some View {
        NavigationStack {
            Form {
                // はじめに（初めて使う人向け）
                Section {
                    DisclosureGroup(isExpanded: $isRecommendedExpanded) {
                        VStack(alignment: .leading, spacing: 12) {
                            Group {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("【台の途中から打つ場合】")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Text("履歴モードで過去の当たりを登録→実戦モードに切り替え")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("【朝一から打つ場合】")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    Text("最初から実戦モードで使用")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.leading, labelTextLeadingOffset)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label {
                            Text("おすすめの使い方")
                        } icon: {
                            IconBadgeView(systemName: "lightbulb.fill", backgroundColor: .yellow)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: rowVerticalInset, leading: rowLeadingInset, bottom: rowVerticalInset, trailing: rowTrailingInset))
                    .listRowSeparator(.hidden)
                } header: {
                    Label("はじめに", systemImage: "sparkles")
                } footer: {
                    Text("初めて使う方はこちらから")
                }

                // 基本操作（操作を確認したい人向け）
                Section {
                    DisclosureGroup(isExpanded: $isModeToggleExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            Group {
                                bulletItem("入力欄右端のボタンでモード切替")
                                bulletItem("青＝履歴入力モード")
                                bulletItem("オレンジ＝実戦入力モード")
                                bulletItem("履歴が空の時は切替不可")
                            }
                            .padding(.leading, labelTextLeadingOffset)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label {
                            Text("モード切り替え")
                        } icon: {
                            IconBadgeView(systemName: "arrow.left.arrow.right", backgroundColor: .gray)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: rowVerticalInset, leading: rowLeadingInset, bottom: rowVerticalInset, trailing: rowTrailingInset))
                    .listRowSeparator(.hidden)

                    DisclosureGroup(isExpanded: $isCurrentEditExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            Group {
                                bulletItem("実戦モードで「現在」ボタンを押す")
                                bulletItem("既存の現在Gが更新される")
                                bulletItem("新しい行は追加されない")
                            }
                            .padding(.leading, labelTextLeadingOffset)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label {
                            Text("現在Gの編集方法")
                        } icon: {
                            IconBadgeView(systemName: "pencil", backgroundColor: .gray)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: rowVerticalInset, leading: rowLeadingInset, bottom: rowVerticalInset, trailing: rowTrailingInset))
                    .listRowSeparator(.hidden)
                } header: {
                    Label("基本操作", systemImage: "hand.tap")
                } footer: {
                    Text("操作方法を確認したい時に")
                }

                // モード詳細（詳しく知りたい人向け）
                Section {
                    DisclosureGroup(isExpanded: $isHistoryModeExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            Group {
                                bulletItem("過去の履歴を最新から順に登録")
                                bulletItem("新しい履歴は下に追加")
                                bulletItem("RB / BB / 最終 ボタンが有効")
                                bulletItem("「現在」ボタンは無効")
                            }
                            .padding(.leading, labelTextLeadingOffset)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label {
                            Text("履歴入力モード")
                        } icon: {
                            IconBadgeView(systemName: "arrow.down", backgroundColor: InputMode.history.color)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: rowVerticalInset, leading: rowLeadingInset, bottom: rowVerticalInset, trailing: rowTrailingInset))
                    .listRowSeparator(.hidden)

                    DisclosureGroup(isExpanded: $isRealtimeModeExpanded) {
                        VStack(alignment: .leading, spacing: 8) {
                            Group {
                                bulletItem("リアルタイムで当たりを記録")
                                bulletItem("新しい履歴は上に追加")
                                bulletItem("現在 / RB / BB ボタンが有効")
                                bulletItem("「最終」ボタンは無効")
                            }
                            .padding(.leading, labelTextLeadingOffset)
                        }
                        .padding(.vertical, 4)
                    } label: {
                        Label {
                            Text("実戦入力モード")
                        } icon: {
                            IconBadgeView(systemName: "arrow.up", backgroundColor: InputMode.realtime.color)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: rowVerticalInset, leading: rowLeadingInset, bottom: rowVerticalInset, trailing: rowTrailingInset))
                    .listRowSeparator(.hidden)
                } header: {
                    Label("モード詳細", systemImage: "book")
                } footer: {
                    Text("各モードの詳細を知りたい時に")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("使い方ガイド")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完了") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    /// 箇条書きアイテム
    private func bulletItem(_ text: String) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Text("•")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

}

#Preview {
    HelpSheetView()
}
