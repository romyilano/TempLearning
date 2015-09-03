//
//  GameController.swift
//  Cat Maze
//
//  Created by Gabriel Hauber on 22/04/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameController: NSObject {

  let view: CCView

  // The scene draws the tiles and cookie sprites, and handles swipes.
  let scene: GameScene

  // background music palyer
  let backgroundMusicPlayer: AVAudioPlayer = {
    let url = NSBundle.mainBundle().URLForResource("SuddenDefeat", withExtension: "mp3")
    let player = AVAudioPlayer(contentsOfURL: url, error: nil)
    player.numberOfLoops = -1
    player.prepareToPlay()
    return player
  }()

  init(skView: CCView) {
    view = skView

    // Create and configure the scene
    scene = GameScene(size: skView.bounds.size, levelName: "Level_0")
    scene.scaleMode = .AspectFill

    super.init()

    // Present the scene
    skView.presentScene(scene)
  }

  func beginGame() {
    backgroundMusicPlayer.play()
    scene.spawnCat()
  }

}
