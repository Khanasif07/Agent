//
//  ImageViewerVC.swift
//  ArabianTyres
//
//  Created by Admin on 27/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//
import UIKit

class ImageViewerVC: BaseVC {
        
    //MARK: VARIABLES
    //===============
    var mainImageURL: String = ""
    var mainImage: UIImage?
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDismiss(_:)))
    lazy var tapTwice = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
    
    //MARK: OUTLETS
    //=============
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    
    //MARK: VIEW LIFE CYCLE
    //=====================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: ACTIONS
    //=============
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}

//MARK: PRIVATE FUNCTIONS
//=======================
extension ImageViewerVC {
    
    private func initialSetup() {
        setupImageView()
        setupSwipe()
        setupTaps()
        setupScrollView()
        setupCloseButton()
    }
    
    
    private func setupCloseButton() {
        self.closeBtn.backgroundColor = UIColor.clear
        self.closeBtn.tintColor = UIColor.clear
    }
    
    private func setupImageView() {
        fullImageView.contentMode = .scaleAspectFit
        fullImageView.setImage_kf(imageString: mainImageURL)
        fullImageView.isUserInteractionEnabled = true
    }
    
    private func setupSwipe() {
        fullImageView.isUserInteractionEnabled = true
        swipeDown.direction = .down
        fullImageView.addGestureRecognizer(swipeDown)
    }
    
    private func setupTaps() {
        fullImageView.isUserInteractionEnabled = true
        tapTwice.numberOfTouchesRequired = 2
        fullImageView.addGestureRecognizer(tapTwice)
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
    }
    
    @objc private func swipeDismiss(_ gesture: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doubleTap(_ gesture: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)

        if scale != scrollView.zoomScale {
            let point = gesture.location(in: fullImageView)
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scale,
                              height: scrollSize.height / scale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        }
    }
}

//MARK: SCROLL VIEW DELEGATES
//===========================
extension ImageViewerVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }

}
