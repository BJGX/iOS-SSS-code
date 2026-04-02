//
//  SceneDelegate.swift

//
//  Created by  on 2025/7/30.
//

import UIKit
import AdjustSdk
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate,UIGestureRecognizerDelegate {

    var window: UIWindow?
    var touchFeedbackView:TouchFeedbackView!
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        if DeviceHelper.isiPadOnMac{
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 800, height: 850);
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 800, height: 850);
        }
        self.window = UIWindow(windowScene: windowScene);
        if DeviceHelper.isiPadOnMac{
            self.window!.frame = CGRect(x: 0, y: 0, width: 800, height: 850)
        }
        
        
        FCVPNManager.shared().stopVPN()
        
        
        self.window?.overrideUserInterfaceStyle = .light;
        NPLanguageTool.shared().initUserLanguage();
        YQUserModel.getUserInfo();
        loginSuccess()

        addNotification()
        
    
        
        return

    }
    
    
    static var isiPad: Bool {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        return UIDevice.current.userInterfaceIdiom == .pad
        #endif
    }
    

    
    public func addNotification() {
//        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NotificationName.loginSuccess.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name:NSNotification.Name("switchLanguage"), object: nil)
    }
    
    @objc private func loginSuccess() {
        showTabbar()
    }
    
    @objc public func showLogin() {
        
        YQUserModel.loginOutUser()
        
        
//        return
//        let loginVC = LoginViewController()
//        let nav = UINavigationController(rootViewController: loginVC)
//        nav.navigationBar.isHidden = true
//        self.window?.rootViewController = nav
    }
    
    public func showTabbar() {
        let tabbar = YQTabBarController()
//        tabbar.view.frame = CGRect(x: 0, y: 0, width: 400, height: 819);
        tabbar.reloadTabBarUI(false)
        self.window?.rootViewController = tabbar;
        window?.makeKeyAndVisible()
//        if YQUserModel.shared().user.isLogin == false {
//            YQUserModel.loginOutUser();
//        }
//        self.touchFeedbackView = TouchFeedbackView(frame: self.window!.bounds);
//        self.window!.addSubview(self.touchFeedbackView)
//        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapRecognizer.cancelsTouchesInView = false;
//        tapRecognizer.delegate = self;
//        self.window!.addGestureRecognizer(tapRecognizer);
        
//        let tabbar = HomeTabbarViewController()
//        self.window?.rootViewController = tabbar
    }
    
    public func showLaunch() {
         let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
         let viewController = storyboard.instantiateViewController(withIdentifier: "launch")
         self.window?.rootViewController = viewController
        
     
        
     }
     
     
     @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
         if recognizer.state == .ended {
             let point = recognizer.location(in: self.touchFeedbackView)
             self.touchFeedbackView.showTouch(at: point);
         }
     }
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
         return true
     }
    
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        FCVPNManager.stopVPN();
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        QYCommonFuncation.upldateApp()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    



}


struct DeviceHelper {
    
    /// 设备类型枚举
    enum DeviceType {
        case iPhone
        case iPad
        case iPadOnMac
    }
    
    /// 获取当前设备类型
    static var currentDeviceType: DeviceType {
        #if targetEnvironment(macCatalyst)
        return .iPadOnMac
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            // 检查是否在 Mac 上运行（通过 iOS 14+ 的 API）
            if #available(iOS 14.0, *) {
                if ProcessInfo.processInfo.isiOSAppOnMac {
                    return .iPadOnMac
                }
            }
            return .iPad
        } else {
            return .iPhone
        }
        #endif
    }
    
    /// 便捷属性
    static var isiPhone: Bool {
        return currentDeviceType == .iPhone
    }
    
    static var isiPad: Bool {
        return currentDeviceType == .iPad
    }
    
    static var isiPadOnMac: Bool {
        return currentDeviceType == .iPadOnMac
    }
}

