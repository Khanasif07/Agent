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
        case payment
        case downloadInvoice
        
        var text :String {
            switch self {
            case .aboutUs:
                return LocalizedString.aboutUs.localized
            case .privacyPolicy:
                return LocalizedString.privacy_policy.localized
            case .termsCondition:
                return LocalizedString.terms_Condition.localized
            case .payment:
                return LocalizedString.payments.localized
            case .downloadInvoice:
                return LocalizedString.download_Invoice.localized
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
            case .payment:
                return baseUrl + WebServices.EndPoint.payment.rawValue
            case .downloadInvoice:
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
    var requestId : String = ""
    var pdfUrl  : String = ""
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // CommonFunctions.showActivityLoader()
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
        webView.scrollView.delegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        webView.uiDelegate = self
        webView.addGestureRecognizer(DisableDoubleTapRecognizer())
        webView.backgroundColor = .white
        containerView.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    private func loadUrl() {
        if webViewType == .payment{
            guard let url = URL(string: webViewType.url + "/" + self.requestId) else {return}
            request = URLRequest(url: url)
            webView.load(request)
            return
        }
        if webViewType == .downloadInvoice{
            guard let url = URL(string: pdfUrl) else {return}
            request = URLRequest(url: url)
            webView.load(request)
            return
        }
        guard let url = URL(string: webViewType.url) else {return}
        request = URLRequest(url: url)
        webView.load(request)
    }
    
}

extension WebViewController: WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url?.absoluteString{
            if url.contains(s: "paymentRedirectUrl") && url.contains(s: "status=paid"){
                NotificationCenter.default.post(name: Notification.Name.PaymentSucessfullyDone, object: nil)
                CommonFunctions.delay(delay: 2.5) {
                    self.pop()
                }
            }
        }
        printDebug(webView.url?.absoluteString)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        printDebug("web view close")
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message:
        String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () ->
        Void) {
        let alertController = UIAlertController(title: message,message: nil,preferredStyle:
            .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel) {_ in
            completionHandler()})
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        printDebug("web view close")
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
             scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollView.setZoomScale(1.0, animated: false)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
         scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

//MARK:- Disbale double tap gesture
//================================
class DisableDoubleTapRecognizer : UITapGestureRecognizer, UIGestureRecognizerDelegate{
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    init() {
        super.init(target:nil, action: nil)
        self.numberOfTapsRequired = 2;
        self.delegate = self;
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}
