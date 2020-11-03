//
//  WebViewController.swift
//  Tara
//
//  Created by Arvind on 31/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: BaseVC {
    
    enum WebViewType {
        case aboutUs
        case privacyPolicy
        case termsCondition
        
        var text :String {
            switch self {
            case .aboutUs:
                return LocalizedString.aboutUs.localized
            case .privacyPolicy:
                return LocalizedString.privacy_policy.localized
            case .termsCondition:
                return LocalizedString.terms_Condition.localized
            }
        }
        
        var url : String {
            switch self {
                
            case .aboutUs:
                return "https://google.com"
            case .privacyPolicy:
                return "https://google.com"
            case .termsCondition:
                return "https://google.com"
                
            }
        }
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Variables
    //===========================
    var webViewType : WebViewType = .aboutUs
    var webView : WKWebView!
    var request : URLRequest!
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CommonFunctions.showActivityLoader()
    }
    
    // MARK: - IBActions
    //===========================
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        pop()
    }
    
    // MARK: - Functions
    //===========================
    private func initialSetup() {
        setupView()
        loadUrl()
        titleLbl.text = webViewType.text
        
    }
    
    
    private func setupView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: webConfig)
        webView.backgroundColor = .white
        containerView.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func loadUrl() {
        guard let url = URL(string: webViewType.url) else {return}
        request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension WebViewController: WKUIDelegate,WKNavigationDelegate {
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        CommonFunctions.hideActivityLoader()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        CommonFunctions.hideActivityLoader()
        
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        printDebug("web view close")
    }
}