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
    }
    
    private func createTabVC(vc: UIViewController.Type, storyBoard: AppStoryboard) -> UIViewController {
        let scene = UINavigationController(rootViewController: vc.instantiate(fromAppStoryboard: storyBoard))
        scene.navigationBar.isHidden = true
        scene.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        return scene
    }
    
    func setupTabBar() {
        let firstScene = createTabVC(vc: HomeVC.self, storyBoard: .Home)
        let secondScene = createTabVC(vc: ExploreVC.self, storyBoard: .Home)
        let thirdScene = createTabVC(vc: NotificationVC.self, storyBoard: .Home)
        let fourthScene = createTabVC(vc: SettingVC.self, storyBoard: .Home)
        let fifthScene = createTabVC(vc: ProfileVC.self, storyBoard: .Home)
        self.viewControllers = [firstScene, secondScene, thirdScene, fourthScene,fifthScene]
        guard let tabBarItems = self.tabBar.items else {return}
        for index in 0...tabBarItems.endIndex - 1 {
            switch index {
            case 0:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "home")
                    item.selectedImage = #imageLiteral(resourceName: "home")
                }
            case 1:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "secondTab")
                    item.selectedImage = #imageLiteral(resourceName: "secondTab")
                }
            case 2:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "notification")
                    item.selectedImage = #imageLiteral(resourceName: "notification")
                }
            case 3:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "setting")
                    item.selectedImage = #imageLiteral(resourceName: "setting")
                }
            default:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "profile")
                    item.selectedImage = #imageLiteral(resourceName: "profile")
                }
            }
        }
    }
}
extension UserTabBarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
       return true
    }
}
