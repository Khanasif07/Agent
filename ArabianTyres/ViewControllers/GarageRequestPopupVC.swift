//
//  GarageRequestPopupVC.swift
//  ArabianTyres
//
//  Created by Arvind on 16/10/20.
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit
import KDCircularProgress

class GarageRequestPopupVC: BaseVC {
 
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var serviceTypeLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var secLbl: UILabel!
    @IBOutlet weak var viewBtn: AppButton!
    @IBOutlet weak var ignoreBtn: AppButton!
    @IBOutlet weak var casCadFirstView: UIView!
    @IBOutlet weak var casCadSecondView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var circularView: KDCircularProgress!
    @IBOutlet weak var bidAmountLbl: UILabel!

    // MARK: - Variables
    //===========================
    var requestData: RequestModel? = nil
    var counter : Int = 20
    var timer : Timer? = nil
    var onDismiss : (()->())?
    var viewBtnTapped : ((String,String)->())?
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.createShadow(shadowColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))

    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func ignoreBtnAction(_ sender: Any) {
        timer?.invalidate()
        dismiss(animated: true, completion: {
            self.onDismiss?()
        })
    }
    
    @IBAction func viewBtnAction(_ sender: Any) {
        timer?.invalidate()
        dismiss(animated: true, completion: {
            self.onDismiss?()
            self.viewBtnTapped?(self.requestData?.requestId ?? "", "Tyres")
        })
    }
    
    @objc func updateCounter() {
        if counter > 0 {
            timeLbl.text = String(counter)
            counter -= 1
        }else {
            timer?.invalidate()
            dismiss(animated: true, completion: {
                self.onDismiss?()
            })
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension GarageRequestPopupVC {
    
    private func initialSetup() {
        setupTextAndFont()
        setupRequestData()
        startTimer()
        circularView.set(colors: #colorLiteral(red: 0.4980392157, green: 0.7490196078, blue: 0.1490196078, alpha: 1) , #colorLiteral(red: 0.9843137255, green: 0.7058823529, blue: 0.03921568627, alpha: 1))
    }
    
    private func setupTextAndFont(){
        serviceTypeLbl.font = AppFonts.NunitoSansBold.withSize(14.0)
        distanceLbl.font = AppFonts.NunitoSansSemiBold.withSize(13.0)
        timeLbl.font = AppFonts.NunitoSansBold.withSize(22.0)
        secLbl.font = AppFonts.NunitoSansSemiBold.withSize(12.0)

    }
    
    
    private func setupRequestData() {
        userImgView.setImage_kf(imageString: requestData?.userImage ?? "", placeHolderImage: #imageLiteral(resourceName: "placeHolder"))
        switch requestData?.distance {
        case .double(let distance):
            distanceLbl.text = "\(distance)" + " miles"
        default:
            break
        }
        bidAmountLbl.text = (requestData?.amount?.description ?? "") + " SAR"
        
        var str: NSMutableAttributedString = NSMutableAttributedString()
            str = NSMutableAttributedString(string: requestData?.garageName ?? "", attributes: [
                           .font: AppFonts.NunitoSansBold.withSize(14.0),
                           .foregroundColor: AppColors.fontPrimaryColor
                       ])
            
            str.append(NSAttributedString(string: " placed a bid on your service request", attributes: [NSAttributedString.Key.foregroundColor: AppColors.fontSecondaryColor,NSAttributedString.Key.font: AppFonts.NunitoSansSemiBold.withSize(13.0)]))
        serviceTypeLbl.attributedText = str
    }
    
    
  
    
    private func startTimer() {
        guard let createdDate = requestData?.time.toDate(dateFormat: Date.DateFormat.givenDateFormat.rawValue) else {return}
        let currentDate = Date()
        let seconds = Date().getSecondFromTwoDate(fromDate: createdDate, toDate: currentDate)
        let diff = counter - seconds
        printDebug("============\n")
        printDebug(seconds)
        printDebug("============\n")
        
        if diff <= 0 {
            dismiss(animated: false)
        }else {
            counter = diff
            timeLbl.text = String(counter)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            CommonFunctions.delay(delay: 0.1) {
                self.circularView.animate(toAngle: 0, duration: TimeInterval(self.counter), completion: nil)
            }
        }
    }
}
