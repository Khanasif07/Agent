//
//  UserTabBarController.swift
//  ArabianTyres
//
//  Created by Admin on 07/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserTabBarController: UITabBarController {
    
    // MARK: - IBOutlets
    //===========================
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
}

// MARK: - Extension for functions
//====================================
extension UserTabBarController {
    
    private func initialSetup() {
        self.navigationController?.navigationBar.isHidden = true
        UITabBar.appearance().tintColor = AppColors.primaryBlueColor
        UITabBar.appearance().unselectedItemTintColor = AppColors.fontTertiaryColor
        self.tabBar.backgroundColor = UIColor.white
        setupTabBar()
        self.delegate = self
//        setUpNavigationBar()
    }
    
    private func createTabVC(vc: UIViewController.Type, storyBoard: AppStoryboard) -> UIViewController {
        let scene = UINavigationController(rootViewController: vc.instantiate(fromAppStoryboard: storyBoard))
        scene.navigationBar.isHidden = true
        scene.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        return scene
    }
    
    func setupTabBar() {
        let firstScene = createTabVC(vc: UnderDevelopmentVC.self, storyBoard: .PostLogin)
        let secondScene = createTabVC(vc: UnderDevelopmentVC.self, storyBoard: .PostLogin)
        let thirdScene = createTabVC(vc: UnderDevelopmentVC.self, storyBoard: .PostLogin)
        let fourthScene = createTabVC(vc: UnderDevelopmentVC.self, storyBoard: .PostLogin)
        self.viewControllers = [firstScene, secondScene, thirdScene, fourthScene]
        guard let tabBarItems = self.tabBar.items else {return}
        for index in 0...tabBarItems.endIndex - 1 {
            switch index {
            case 0:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "icHome")
                    item.title = LocalizedString.home.localized
                    item.selectedImage = #imageLiteral(resourceName: "icHome")
                    item.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.MuliRegular.withSize(10)], for: .normal)
                }
            case 1:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "icExplore")
                    item.title = LocalizedString.setting.localized
                    item.selectedImage = #imageLiteral(resourceName: "icExplore")
                    item.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.MuliRegular.withSize(10)], for: .normal)
                }
            case 2:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "group3125")
                    item.title = LocalizedString.notification.localized
                    item.selectedImage = #imageLiteral(resourceName: "group3125")
                    item.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.MuliRegular.withSize(10)], for: .normal)
                }
            default:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "icProfile-1")
                    item.title = LocalizedString.profile.localized
                    item.selectedImage = #imageLiteral(resourceName: "icProfile-1")
                    item.setTitleTextAttributes([NSAttributedString.Key.font: AppFonts.MuliRegular.withSize(10)], for: .normal)
                }
            }
        }
    }
    
//    private func setUpNavigationBar(){
//        let logo = #imageLiteral(resourceName: "iTunesArtwork")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
//    }
}
extension UserTabBarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       return true
    }
}
