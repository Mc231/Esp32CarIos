//
//  WebViewRepresentable.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 25.10.2023.
//

import WebKit
import SwiftUI

// Placeholder WebViewRepresentable for the example. You may need to modify this to suit your streaming needs.
struct WebViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

        if let url = BaseUrlProvider.default.provide(baseUrl: .stream) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
