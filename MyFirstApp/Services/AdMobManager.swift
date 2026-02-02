//
//  AdMobManager.swift
//  MyFirstApp
//
//  AdMob広告の初期化・読み込み・表示管理
//

import Combine
import GoogleMobileAds
import UIKit

@MainActor
final class AdMobManager: NSObject, ObservableObject {
    static let shared = AdMobManager()

    @Published private(set) var isInterstitialReady = false
    private var interstitialAd: GADInterstitialAd?
    private var lastInterstitialShowTime: Date?
    private let minimumInterval: TimeInterval = 60  // 最小間隔（秒）

    private override init() {
        super.init()
    }

    /// AdMob SDKを初期化
    func initialize() {
        GADMobileAds.sharedInstance().start { status in
            print("[AdMob] SDK initialized: \(status.adapterStatusesByClassName)")
            Task { @MainActor in
                self.loadInterstitialAd()
            }
        }
    }

    /// インタースティシャル広告をプリロード
    func loadInterstitialAd() {
        GADInterstitialAd.load(
            withAdUnitID: AdConfig.interstitialAdUnitID,
            request: GADRequest()
        ) { [weak self] ad, error in
            Task { @MainActor in
                if let error = error {
                    print("[AdMob] Interstitial load failed: \(error.localizedDescription)")
                    self?.isInterstitialReady = false
                    return
                }
                self?.interstitialAd = ad
                self?.interstitialAd?.fullScreenContentDelegate = self
                self?.isInterstitialReady = true
                print("[AdMob] Interstitial loaded successfully")
            }
        }
    }

    /// インタースティシャル広告を表示
    func showInterstitialAd() {
        // 最小間隔チェック
        if let lastShow = lastInterstitialShowTime {
            let elapsed = Date().timeIntervalSince(lastShow)
            if elapsed < minimumInterval {
                print("[AdMob] Skipped: only \(Int(elapsed))s since last ad (min: \(Int(minimumInterval))s)")
                return
            }
        }

        guard let ad = interstitialAd else {
            print("[AdMob] Interstitial not ready")
            loadInterstitialAd()
            return
        }

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("[AdMob] No root view controller")
            return
        }

        // 最前面のViewControllerを取得
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }

        lastInterstitialShowTime = Date()
        ad.present(fromRootViewController: topController)
    }
}

// MARK: - GADFullScreenContentDelegate
extension AdMobManager: GADFullScreenContentDelegate {
    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            print("[AdMob] Interstitial dismissed")
            self.interstitialAd = nil
            self.isInterstitialReady = false
            self.loadInterstitialAd()
        }
    }

    nonisolated func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            print("[AdMob] Interstitial failed to present: \(error.localizedDescription)")
            self.interstitialAd = nil
            self.isInterstitialReady = false
            self.loadInterstitialAd()
        }
    }

    nonisolated func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[AdMob] Interstitial will present")
    }
}
