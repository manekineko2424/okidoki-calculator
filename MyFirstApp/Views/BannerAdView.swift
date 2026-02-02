//
//  BannerAdView.swift
//  MyFirstApp
//
//  SwiftUIラッパー for GADBannerView
//

import SwiftUI
import GoogleMobileAds

struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView()
        bannerView.adUnitID = adUnitID
        bannerView.delegate = context.coordinator
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        // アダプティブバナーサイズを計算
        let viewWidth = UIScreen.main.bounds.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // View階層確立後にrootViewControllerを設定して広告をロード
        if uiView.rootViewController == nil {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                uiView.rootViewController = rootVC
                uiView.load(GADRequest())
            }
        }
    }

    class Coordinator: NSObject, GADBannerViewDelegate {
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("[AdMob] Banner loaded successfully")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("[AdMob] Banner failed: \(error.localizedDescription)")
        }
    }
}

/// バナー広告の高さを取得するためのヘルパー
struct BannerAdHeight {
    static var adaptive: CGFloat {
        let viewWidth = UIScreen.main.bounds.width
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth).size.height
    }
}
