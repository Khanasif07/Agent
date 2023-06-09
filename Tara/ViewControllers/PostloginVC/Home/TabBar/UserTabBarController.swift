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
extension UserTabBarController {
    
    private func initialSetup() {
       // setupTabBarBackGroundView(itemIndex: 0)
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
    
    private func setupTabBarBackGroundView(itemIndex: Int) {
        self.tabBar.barTintColor = UIColor.blue
        guard let itemView = self.tabBar.items?[itemIndex].value(forKey: "view") as? UIView else {return}
        printDebug(itemView.frame)
        let viewOverTabBar = UIView()
        //viewOverTabBar.frame = itemView.frame
        viewOverTabBar.centerX = itemView.origin.x
        viewOverTabBar.frame.size = CGSize(width: 48.0, height: 48.0)
        viewOverTabBar.backgroundColor = AppColors.appRedColor
        viewOverTabBar.roundCorner([.bottomLeft,.bottomRight], radius: 10.0)
        itemView.addSubview(viewOverTabBar)
        self.view.layoutIfNeeded()
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
//        setupTabBarBackGroundView(itemIndex: 0)
        self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: AppColors.appRedColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.init(top: 0, left: 0, bottom: bottomSafeArea, right: 0))
    }
    
    func setupTabBar() {
        let firstScene = createTabVC(vc: HomeVC.self, storyBoard: .Home)
        let secondScene = createTabVC(vc: UserAllRequestVC.self, storyBoard: .Garage)
        let thirdScene = createTabVC(vc: UserNotificationVC.self, storyBoard: .UserHomeScreen)
        let fourthScene = createTabVC(vc: UserChatVC.self, storyBoard: .Chat)
        let fifthScene = createTabVC(vc: ProfileVC.self, storyBoard: .Home)
        self.viewControllers = [firstScene, secondScene, thirdScene, fourthScene,fifthScene]
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
                    item.image = #imageLiteral(resourceName: "notification")
                    item.selectedImage = #imageLiteral(resourceName: "notification")
                }
            case 3:
                if let item = self.tabBar.items?[index] {
                    item.image = #imageLiteral(resourceName: "group3697")
                    item.selectedImage = #imageLiteral(resourceName: "group3697")
                    
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
extension UserTabBarController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        tabBar.selectedImageTintColor = .white
        //setupTabBarBackGroundView(itemIndex: tabBarController.selectedIndex)
       tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: AppColors.appRedColor, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: bottomSafeArea, right: 10))
    
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        guard let vc = (viewController as? UINavigationController)?.viewControllers.first else {return true}
//        if vc is UserAllRequestVC || vc is NotificationVC || vc is SettingVC{
//            if !isUserLoggedin {
//                ToastView.shared.showLongToast(self.view, msg: "To continue performing this action, please login")
//                return false
//            }
//        }
        return true
    }
}

extension UIImage {

  class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 10, y: 0, width: size.width - 20.0, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
    return image
    }

}

