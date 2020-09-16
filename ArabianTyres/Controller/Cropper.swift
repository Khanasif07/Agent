//
//  Cropper.swift
//  ArabianTyres
//
//  Created by Admin on 16/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import RSKImageCropper

@objc public protocol CropperDelegate: NSObjectProtocol {
    
    /**
     Tells the delegate that crop image has been canceled.
     */
    @objc optional func imageCropperDidCancelCrop()
    
    
    /**
     Tells the delegate that the original image will be cropped.
     */
    @objc optional func imageCropper(willCropImage originalImage: UIImage)
    
    
    /**
     Tells the delegate that the original image has been cropped. Additionally provides a crop rect used to produce image.
     */
    @objc optional func imageCropper(didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect)
    
    
    /**
     Tells the delegate that the original image has been cropped. Additionally provides a crop rect and a rotation angle used to produce image.
     */
    @objc optional func imageCropper(didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat)
}

class Cropper: NSObject {
    
    enum CropperMode {
        case circle
        case square
        case custom(CGRect)
    }
    
    static let shared : Cropper = Cropper()
    weak var delegate: CropperDelegate?
    
    fileprivate var cropperRect: CGRect!
    typealias CropperDelegateController = (UIViewController & CropperDelegate)
    
    func openCropper(withImage image: UIImage, mode: CropperMode, on controller: CropperDelegateController) {
        
        var cropMode: RSKImageCropMode!
        
        switch mode {
        case .circle:
            cropMode = .circle
            
        case .square:
            cropMode = .square
            
        case .custom(let rect):
            cropMode = .custom
            cropperRect = rect
        }
        
        showCropper(image: image, mode: cropMode, on: controller)
    }
    
    private func showCropper(image: UIImage, mode: RSKImageCropMode, on controller: CropperDelegateController) {
        
        let cropController = RSKImageCropViewController(image: image, cropMode: mode)
//        cropController.isRotationEnabled = false
//        cropController.setZoomScale(0.0)
        cropController.delegate = self
        delegate = controller
        let label = UILabel(frame: CGRect(x: cropController.view.center.x - 100, y: 100, width: 200, height: 30))
        label.textAlignment = .center
        label.text = "Set Preview Image"
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = .white
        cropController.view.addSubview(label)

        if mode == .custom {
            cropController.dataSource = self
        }
        
        if let navCont = controller.navigationController {
            navCont.pushViewController(cropController, animated: true)
            
        } else {
            controller.modalPresentationStyle = .overCurrentContext
            controller.present(cropController, animated: true, completion: nil)
        }
    }
}

// MARK: RSKImageCropViewController DataSource Methods
extension Cropper: RSKImageCropViewControllerDataSource {
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return cropperRect
    }
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        return cropperRect
    }
    
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        return UIBezierPath(rect: cropperRect)
    }
}

// MARK: RSKImageCropViewController Delegate Methods
extension Cropper: RSKImageCropViewControllerDelegate {
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        
        closeCropper(controller)
        delegate?.imageCropperDidCancelCrop?()
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        closeCropper(controller)
        delegate?.imageCropper?(didCropImage: croppedImage, usingCropRect: cropRect)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        delegate?.imageCropper?(willCropImage: originalImage)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        
        closeCropper(controller)
        if delegate?.imageCropper?(didCropImage: croppedImage, usingCropRect: cropRect, rotationAngle: rotationAngle) == nil{
            delegate?.imageCropper?(didCropImage: croppedImage, usingCropRect: cropRect)
        }
    }
    
    private func closeCropper(_ cropper: RSKImageCropViewController) {
        
        if let navCont = cropper.navigationController {
            navCont.popViewController(animated: true)
        } else {
            cropper.dismiss(animated: true, completion: nil)
        }
    }
}

