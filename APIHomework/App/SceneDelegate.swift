//
//  SceneDelegate.swift
//  APIHomework
//
//  Created by Артём Сноегин on 25.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let postsVC = UINavigationController(rootViewController: PostFeedTableViewController())
        postsVC.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        
        let usersVC = UINavigationController(rootViewController: UserListTableViewController())
        usersVC.tabBarItem = UITabBarItem(title: "Users", image: (UIImage(systemName: "person")), selectedImage: UIImage(systemName: "person.fill"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [postsVC, usersVC]
        tabBarController.tabBar.tintColor = .label
        
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

