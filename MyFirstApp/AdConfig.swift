//
//  AdConfig.swift
//  MyFirstApp
//
//  AdMob広告ユニットID定義
//

import Foundation

enum AdConfig {
    /// 広告の有効/無効（開発中はfalse、リリース時にtrueに変更）
    static let isEnabled = false

    static let appID = "ca-app-pub-6638862282281249~5810149582"

    #if DEBUG
    // テスト用ID（Googleが提供）
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    static let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
    #else
    // 本番用ID
    static let bannerAdUnitID = "ca-app-pub-6638862282281249/5993547642"
    static let interstitialAdUnitID = "ca-app-pub-6638862282281249/7865467283"
    #endif
}
