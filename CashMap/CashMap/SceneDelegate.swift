//
//  SceneDelegate.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Configure split view controller navigation delegates
        guard
            let splitViewController = window?.rootViewController as? UISplitViewController,
            let leftNavViewController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavViewController.viewControllers.first as? SpendsTableViewController,
            let rightNavViewController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavViewController.viewControllers.first as? CashMapViewController
        else { fatalError() }
        
        masterViewController.delegate = detailViewController
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

