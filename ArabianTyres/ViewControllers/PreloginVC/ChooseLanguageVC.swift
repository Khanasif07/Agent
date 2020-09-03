//
//  ChooseLanguageVC.swift
//  ArabianTyres
//
//  Created by Admin on 03/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChooseLanguageVC: BaseVC {
    
    
    // MARK: - Properties
    //===========================
    let tutorialImages : [UIImage] = [#imageLiteral(resourceName: "illustration1"),#imageLiteral(resourceName: "illustration2"),#imageLiteral(resourceName: "illustration3")]
    let tutorialTitles : [String] = [LocalizedString.tutorialTitle1.localized,LocalizedString.tutorialTitle2.localized,LocalizedString.tutorialTitle3.localized]
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var tutorialCollView: UICollectionView!
    @IBOutlet weak var arabicLbl: UILabel!
    @IBOutlet weak var englishLbl: UILabel!
    @IBOutlet weak var arabicBtn: UIButton!
    @IBOutlet weak var englishBtn: UIButton!
    @IBOutlet weak var arabicBtnView: UIView!
    @IBOutlet weak var englishBtnView: UIView!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Variables
    //===========================
    
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
        self.englishBtnView.layer.borderWidth = 1.0
        self.arabicBtnView.layer.borderWidth = 1.0
        self.englishBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.arabicBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.arabicBtnView.round(radius: 4.0)
        self.englishBtnView.round(radius: 4.0)
        self.continueBtn.round(radius: 4.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tutorialCollView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func englishBtnAction(_ sender: UIButton) {
        self.englishBtn.setImage(#imageLiteral(resourceName: "group1431"), for: .normal)
        self.arabicBtn.setImage(#imageLiteral(resourceName: "roundUnSelected"), for: .normal)
        self.englishBtnView.layer.borderColor = AppColors.primaryBlueColor.cgColor
        self.arabicBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.englishBtnView.layer.borderWidth = 1.5
        self.arabicBtnView.layer.borderWidth = 1.0
        self.continueBtn.backgroundColor = AppColors.primaryBlueColor
        self.continueBtn.titleLabel?.textColor = .white
        self.continueBtn.isUserInteractionEnabled = true
    }
    
    @IBAction func arabicBtnAction(_ sender: UIButton) {
        self.englishBtn.setImage(#imageLiteral(resourceName: "roundUnSelected"), for: .normal)
        self.arabicBtn.setImage(#imageLiteral(resourceName: "group1431"), for: .normal)
        self.englishBtnView.layer.borderWidth = 1.0
        self.arabicBtnView.layer.borderWidth = 1.5
        self.arabicBtnView.layer.borderColor = AppColors.primaryBlueColor.cgColor
        self.englishBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.continueBtn.backgroundColor = AppColors.primaryBlueColor
        self.continueBtn.titleLabel?.textColor = .white
        self.continueBtn.isUserInteractionEnabled = true
    }
    
}

// MARK: - Extension For Functions
//===========================
extension ChooseLanguageVC {
    
    private func initialSetup() {
        self.setUpColor()
        self.setUpPageControl()
        self.setUpCollectionView()
    }
    
    public func setUpPageControl(){
        self.pageControl.numberOfPages = self.tutorialImages.count
        self.pageControl.currentPageIndicatorTintColor = AppColors.warningYellowColor
        self.pageControl.pageIndicatorTintColor = .white
    }
    
    public func setUpCollectionView(){
        self.tutorialCollView.delegate = self
        self.tutorialCollView.dataSource = self
        self.tutorialCollView.registerCell(with: TutorialCollCell.self)
    }
    
    public func setUpColor(){
        self.continueBtn.backgroundColor = AppColors.primaryBlueLightShade
        self.continueBtn.setTitle(LocalizedString.continueTitle.localized, for: .normal)
        self.englishLbl.text = LocalizedString.english.localized
        self.arabicLbl.text = LocalizedString.arabic.localized
        self.arabicBtn.setImage(#imageLiteral(resourceName: "roundUnSelected"), for: .normal)
        self.englishBtn.setImage(#imageLiteral(resourceName: "roundUnSelected"), for: .normal)
        self.continueBtn.isUserInteractionEnabled = false
    }
}

// MARK: - Extension For TableView
//===========================
extension ChooseLanguageVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tutorialImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: TutorialCollCell.self, indexPath: indexPath)
        cell.populate(withImage : self.tutorialImages[indexPath.row],withTitle : self.tutorialTitles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         printDebug(collectionView.frame.size.height)
        return CGSize(width: UIScreen.width, height: collectionView.frame.size.height)
    }
}


//MARK:- SCROLL VIEW DELEGATE
//===========================
extension ChooseLanguageVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let page = offset.x / self.view.bounds.width
        self.manageScroll(forPage: Int(page))
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let page = offset.x / self.view.bounds.width
        self.manageScroll(forPage: Int(page))
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let page = offset.x / self.view.bounds.width
        self.manageScroll(forPage: Int(page))
    }
    
    func manageScroll(forPage page : Int) {
        self.pageControl.currentPage = page
    }
}
