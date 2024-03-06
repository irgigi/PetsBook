//
//  SceneDelegate.swift
//  PetsBookApp


import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    func currentUserSetup(_ user: User) {
        userUser = FireBaseUser(user: user)
    }
    

    var window: UIWindow?
    var userUser: FireBaseUser?
    var isUser: Bool = false


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: Notification.Name("NotificationName"), object: nil)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)        
        let logoVC = UINavigationController(rootViewController: LogoViewController())
        let usersVC = UINavigationController(rootViewController: UsersFeedController())
        usersVC.tabBarItem = UITabBarItem(title: "PETS", image: UIImage(systemName: "pawprint.fill"), tag: 0)
        //let regVC = UINavigationController(rootViewController: RegViewController())
        
        let tabBarController = MyTabBarController.shared
        tabBarController.viewControllers = [usersVC]
        tabBarController.tabBar.tintColor = Colors.myColor
        tabBarController.tabBar.barTintColor = Colors.myColorLight
        window.rootViewController = logoVC
        window.makeKeyAndVisible()
        self.window = window
        

    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if userInfo["user"] is FireBaseUser {
                let tabBarController = MyTabBarController.shared
                for user in userInfo {
                    if let us = user.value as? FireBaseUser {
                        if isUser {
                            return
                        } else {
                            addVControllers(user: us, tabBarController: tabBarController)
                            if let newWindow = window {
                                tabBarController.selectedIndex = 1
                                newWindow.rootViewController = tabBarController
                                newWindow.makeKeyAndVisible()
                                self.window = newWindow
                                isUser = true
                            }
                        }
                    }
                }
                /*
                AuthService.shared.currentUserHandler = { [self] user in
                    userUser = FireBaseUser(user: user)
                    if let user = userUser {
                        addVControllers(user: user, tabBarController: tabBarController)
                        
                        if let newWindow = window {
                            newWindow.rootViewController = tabBarController
                            newWindow.makeKeyAndVisible()
                            self.window = newWindow
                        }
                    }
                }
                */
            }
        }
    }
    
    func addVControllers(user: FireBaseUser, tabBarController: UITabBarController) {
        
        let profileVC = UINavigationController(rootViewController: ProfileViewController(user: user))
        
        if let controllers = tabBarController.viewControllers {
            if let vc = controllers.firstIndex(where: { $0 is ProfileViewController}) {
                return
            }
        }
        
        
        for vc in tabBarController.viewControllers ?? [] {
            if vc == profileVC {
                return
            } else {
                profileVC.tabBarItem = UITabBarItem(title: "PROFILE", image: UIImage(systemName: "teddybear.fill"), tag: 1)
                tabBarController.viewControllers?.append(profileVC)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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

