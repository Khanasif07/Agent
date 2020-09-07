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
    @IBOutlet weak var chooseLangLbl: UILabel!
    
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
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    @IBAction func continueBtnAction(_ sender: UIButton) {
        let scene = LoginVC.instantiate(fromAppStoryboard: .Prelogin)
        self.navigationController?.pushViewController(scene, animated: true)
    }
    
    @IBAction func englishBtnAction(_ sender: UIButton) {
        self.englishBtnView.layer.borderColor = AppColors.primaryBlueColor.cgColor
        self.arabicBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.englishBtn.setImage(#imageLiteral(resourceName: "group1431"), for: .normal)
        self.arabicBtn.setImage(#imageLiteral(resourceName: "roundUnSelected"), for: .normal)
        self.englishBtnView.layer.borderWidth = 1.5
        self.arabicBtnView.layer.borderWidth = 1.0
        self.continueBtn.backgroundColor = AppColors.primaryBlueColor
        self.continueBtn.titleLabel?.textColor = .white
        self.continueBtn.isUserInteractionEnabled = true
        AppUserDefaults.save(value: LocalizedString.english.localized, forKey: .currentLanguage)
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
        AppUserDefaults.save(value: LocalizedString.arabic.localized, forKey: .currentLanguage)
    }
    
    @IBAction func scrollToNextPage(_ sender: UIButton) {
        self.scrollToNextCell()
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
        self.englishBtnView.layer.borderWidth = 1.0
        self.arabicBtnView.layer.borderWidth = 1.0
        self.englishBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.arabicBtnView.layer.borderColor = AppColors.primaryBlueLightShade.cgColor
        self.chooseLangLbl.text = LocalizedString.chooseLanguage.localized
    }
    
    private func scrollToNextCell(){
        if let coll = tutorialCollView{
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)! < tutorialImages.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
