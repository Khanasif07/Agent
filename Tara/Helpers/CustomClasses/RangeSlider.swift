//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Rajan Singh on 06/08/20.
//  Copyright © 2020 Rajan Singh. All rights reserved.
//

import UIKit

protocol RangeSliderDelegate: class {
    func rangeSlider(selectedValue: Int)
}

class RangeSlider: UIView {
    
    weak var delegate: RangeSliderDelegate?
    var leftConstraint = NSLayoutConstraint()
    
    var sliderTitle: String = "" {
        didSet {
            titleLabel.text = sliderTitle
        }
    }
    
    var value: CGFloat {
        get {
            return CGFloat(slider.value)
        }
        set {
            slider.value = Float(newValue)
            titleLabel.text = String(format: "%.2f", newValue) + " Miles"
        }
    }
    
    var minValue: CGFloat = 0 {
        didSet {
            slider.minimumValue = Float(minValue)
        }
    }
    
    var maxValue: CGFloat = 1 {
        didSet {
            slider.maximumValue = Float(maxValue)
        }
    }
    
    var handleTintColor: UIColor = AppColors.fontPrimaryColor {
        didSet {
            updateHandleTintColor()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.NunitoSansBold.withSize(13.0)
        label.textColor = #colorLiteral(red: 0.262745098, green: 0.6941176471, blue: 0.3294117647, alpha: 1)
        return label
    }()
    
    private lazy var minValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.NunitoSansBold.withSize(13.0)
        label.textColor = #colorLiteral(red: 0.262745098, green: 0.6941176471, blue: 0.3294117647, alpha: 1)
        label.isHidden = true
        label.text = "500"
        return label
    }()
    
    private lazy var maxValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFonts.NunitoSansBold.withSize(13.0)
        label.textColor = AppColors.fontTertiaryColor
        label.isHidden = true
        label.text = "2500"
        return label
    }()
    
    private lazy var fakeSlider: CustomSlider = {
        let slider = CustomSlider()
        slider.isUserInteractionEnabled = false
        slider.tintColor = .clear
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .white
//        slider.isEnabled = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private lazy var slider: CustomSlider = {
        let slider = CustomSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tintColor = AppColors.fontTertiaryColor
        slider.minimumTrackTintColor = #colorLiteral(red: 0.1607843137, green: 0.2588235294, blue: 0.6235294118, alpha: 1)
        slider.maximumTrackTintColor = #colorLiteral(red: 0.8941176471, green: 0.8980392157, blue: 0.937254902, alpha: 1)
        slider.addTarget(self, action: #selector(sliderMoved(slider:event:)), for: .valueChanged)
        return slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    private func layout() {
                
        addSubview(minValueLabel)
        minValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2).isActive = true
        minValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13).isActive = true
        
        addSubview(maxValueLabel)
        maxValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2).isActive = true
        maxValueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13).isActive = true
        
        addSubview(slider)
        slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        slider.heightAnchor.constraint(equalToConstant: 32).isActive = true
        slider.topAnchor.constraint(equalTo: minValueLabel.bottomAnchor, constant: 10).isActive = true
        
        addSubview(fakeSlider)
        fakeSlider.topAnchor.constraint(equalTo: slider.topAnchor).isActive = true
        fakeSlider.bottomAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        fakeSlider.leadingAnchor.constraint(equalTo: slider.leadingAnchor).isActive = true
        fakeSlider.trailingAnchor.constraint(equalTo: slider.trailingAnchor).isActive = true
        
        addSubview(titleLabel)
        leftConstraint = titleLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 25)
        leftConstraint.isActive = true
        titleLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 5).isActive = true

        self.sendSubviewToBack(slider)
        self.bringSubviewToFront(fakeSlider)
        self.sliderThumbSetUp()
    }
    
    func sliderThumbSetUp() {
        let image = #imageLiteral(resourceName: "slider")
        fakeSlider.setThumbImage(image, for: .normal)
        slider.setThumbImage(image, for: .normal)
    }
    
    @objc private func sliderMoved(slider: UISlider, event: UIEvent) {
        titleLabel.text = Int(slider.value * 2500).description //String(format: "%.2f", slider.value*50) + " Miles"
        let trackRect = slider.trackRect(forBounds: slider.frame)
        var sliderValueWithPadding = slider.value
        if slider.value > 0.96 {
            sliderValueWithPadding = 0.96
        }
        else if slider.value < 0.02 {
            sliderValueWithPadding = 0.02
        }
        let thumbRect = slider.thumbRect(forBounds: slider.bounds, trackRect: trackRect, value: sliderValueWithPadding)
        leftConstraint.isActive = false
        leftConstraint.constant = thumbRect.midX
        leftConstraint.isActive = true
        self.delegate?.rangeSlider(selectedValue: Int(slider.value * 2500))
    }
    
    private func updateHandleTintColor() {
        slider.tintColor = handleTintColor
    }
    
    ///Call to reset slider (value from 0 to 1)
    func resetSlider(value: Float = 0) {
        self.slider.value = value
        self.sliderMoved(slider: self.slider, event: UIEvent.init())
    }
    
}

class CustomSlider: UISlider {
    
    @IBInspectable open var trackHeight: CGFloat = 8 {
        didSet {setNeedsDisplay()}
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: trackHeight))
    }
    
    @IBInspectable open var thumbWidth: Float = 32 {
        didSet {setNeedsDisplay()}
    }
    lazy private var startingOffset: Float = 0 - (thumbWidth / 2)
    lazy private var endingOffset: Float = thumbWidth
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let xTranslation: Float =  startingOffset + (minimumValue + endingOffset) / maximumValue * value
        return super.thumbRect(forBounds: bounds, trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation), y: 0)), value: value)
    }
}
