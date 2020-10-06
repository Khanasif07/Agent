//
//  GarageTabBarController.swift
//  ArabianTyres
//
//  Created by Admin on 21/09/20.
//  Copyright © 2020 Admin. All rights reserved.

import UIKit

class GarageTabBarController: UITabBarController {
    
    // MARK: - IBOutlets
    //===========================
    
    // MARK: - Variables
    //===========================
    var bottomSafeArea: CGFloat = 0.0
//    var yourView : UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
    
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            self.bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            self.bottomSafeArea = bottomLayoutGuide.length
        }
    }
    // MARK: - IBActions
    //===========================
    
}

// MARK: - Extension for functions
//====================================
extension GarageTabBarController {
    
    private func initialSetup() {
        self.bottomSafeArea = UIDevice.current.hasNotch ? 34.0 : 0.0
        self.navigationController?.navigationBar.isHidden = true
        UITabBar.appearance().tintColor = AppColors.primaryBlueColor
        UITabBar.appearance().unselectedItemTintColor = AppColors.fontTertiaryColor
        self.tabBar.backgroundColor = UIColor.white
        self.selectedIndex = 0
        self.delegate = self
        setupTabBar()
        firstTabBarSelected()
    }
    
    private func createTabVC(vc: UIViewController.Type, storyBoard: AppStoryboard) -> UIViewController {
        let scene = UINavigationController(rootViewController: vc.instantiate(fromAppStoryboard: storyBoard))
        scene.navigationBar.isHidden = true
        scene.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        return scene
    }
    
    private func firstTabBarSelected(){
        let numberOfItems = CGFloat(self.tabBar.items!.count)
        let tabBarItemSize = CGSize(width: self.tabBar.frame.width / numberOfItems, height: self.tabBar.frame.height)
        self.tabBar.selectedImageTintColor = .white
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: AppColors.appRedColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: bottomSafeArea, right: 0))
    }
    
    func setupTabBar() {
        let firstScene = createTabVC(vc: GarageHomeVC.self, storyBoard: .GarageHome)
        let secondScene = createTabVC(vc: GarageAllRequestVC.self, storyBoard: .Garage)
        let fourthScene = createTabVC(vc: OngoingServiceListingVC.self, storyBoard: .GarageRequest)
        let fifthScene = createTabVC(vc: GarageProfileVC.self, storyBoard: .GarageHome)
        self.viewControllers = [firstScene, secondScene, fourthScene,fifthScene]
        guard let tabBarItems = self.tabBar.items else {return}
        for index in 0...tabBarItems.endIndex - 1 {
            switch index {
            case 0:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "home")
                    item.selectedImage = #imageLiteral(resourceName: "homeSelected")
                }
            case 1:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "secondTab")
                    item.selectedImage = #imageLiteral(resourceName: "secondTab")
                }
            case 2:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "setting")
                    item.selectedImage = #imageLiteral(resourceName: "setting")
                }
            default:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "profile")
                    item.image?.withTintColor(AppColors.primaryBlueColor)
                    item.selectedImage = #imageLiteral(resourceName: "profile")
                }
            }
        }
    }
}
extension GarageTabBarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectedImageTintColor = .white
        tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: AppColors.appRedColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: bottomSafeArea, right: 10))
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       return true
    }
}
