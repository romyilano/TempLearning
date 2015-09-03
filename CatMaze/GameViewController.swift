//
//  GameViewController.swift
//  CatMaze
//
//  Created by Gabriel Hauber on 28/04/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import SpriteKit

// alias the type to make it easier to use cross-platform
typealias CCView = SKView

// minimal logic here - just enough to bootstrap the game before handing
// over to the platform-agnostic shared code
class GameViewController: UIViewController {

  var gameController: GameController!

  // Set up the game controller
  override func viewDidLoad() {
    super.viewDidLoad()

    let skView = view as! CCView
    skView.multipleTouchEnabled = false

    gameController = GameController(skView: skView)
  }

  // The game begins once the view has appeared
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    gameController.beginGame()
  }


  // MARK: - device setup

  override func shouldAutorotate() -> Bool {
    return true
  }

  override func supportedInterfaceOrientations() -> Int {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    } else {
      return Int(UIInterfaceOrientationMask.All.rawValue)
    }
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }

}
