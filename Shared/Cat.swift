//
//  Cat.swift
//  CatMaze
//
//  Created by Gabriel Hauber on 29/04/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit


extension SKAction {
  class func animate(name: String, inDirection direction: String, forFrameCount numFrames: Int, timePerFrame sec: NSTimeInterval) -> SKAction {
    var animationFrames = [SKTexture]()
    for frameNum in 1...numFrames {
      animationFrames.append(SKTexture(imageNamed: "\(name)\(direction)\(frameNum)"))
    }
    return SKAction.animateWithTextures(animationFrames, timePerFrame: sec)
  }
}


class Cat: SKSpriteNode {

  var numBones = 0
  weak var gameScene: GameScene!

  // pre-load the sound resources
  let hitWallSound = SKAction.playSoundFileNamed("hitWall.wav", waitForCompletion: false)
  let pickupBoneSound = SKAction.playSoundFileNamed("pickup.wav", waitForCompletion: false)
  let catAttackSound = SKAction.playSoundFileNamed("catAttack.wav", waitForCompletion: false)
  let stepSound = SKAction.playSoundFileNamed("step.wav", waitForCompletion: false)

  // set up the cat walking animations in all four cardinal directions
  private let facingForwardAnimation = SKAction.animate("Cat", inDirection: "Down", forFrameCount: 2, timePerFrame: 0.1)
  private let facingBackAnimation = SKAction.animate("Cat", inDirection: "Up", forFrameCount: 2, timePerFrame: 0.1)
  private let facingLeftAnimation = SKAction.animate("Cat", inDirection: "Left", forFrameCount: 2, timePerFrame: 0.1)
  private let facingRightAnimation = SKAction.animate("Cat", inDirection: "Right", forFrameCount: 2, timePerFrame: 0.1)


  // MARK: Initialisation

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }

  init() {
    let texture = SKTexture(imageNamed: "CatDown1")
    super.init(texture: texture, color: nil, size: texture.size())
  }

  private func runAnimation(animation: SKAction, withKey key: String) {
    // Sprite Kit will automatically remove any existing animation that matches the key we give
    runAction(SKAction.repeatActionForever(animation), withKey: key)
  }


  // MARK: Actions

  func moveInDirection(direction: Direction) {
    let currentTileCoord = gameScene.tileMap.tileCoordForPosition(position)
    let desiredTileCoord: TileCoord

    switch direction {
    case .Up:
      desiredTileCoord = currentTileCoord.top
      runAnimation(facingBackAnimation, withKey: "catWalk")
    case .Down:
      desiredTileCoord = currentTileCoord.bottom
      runAnimation(facingForwardAnimation, withKey: "catWalk")
    case .Left:
      desiredTileCoord = currentTileCoord.left
      runAnimation(facingLeftAnimation, withKey: "catWalk")
    case .Right:
      desiredTileCoord = currentTileCoord.right
      runAnimation(facingRightAnimation, withKey: "catWalk")
    }

    moveTo(desiredTileCoord)
  }

  func moveToward(target: CGPoint) {
    let diff = target - position
    if abs(diff.x) > abs(diff.y) {
      if diff.x > 0 {
        moveInDirection(.Right)
      } else {
        moveInDirection(.Left)
      }
    } else {
      if diff.y > 0 {
        moveInDirection(.Up)
      } else {
        moveInDirection(.Down)
      }
    }
  }

  func moveTo(toTileCoord: TileCoord) {
    // Get the current and desired tile coordinates
    let fromTileCoord = gameScene.tileMap.tileCoordForPosition(position)

    // Check that we are actually moving somewhere ;-)
    if fromTileCoord == toTileCoord {
      println("You're already there! :P")
      return
    }

    // Must check that the desired location is walkable
    if !gameScene.isWalkableTileForTileCoord(toTileCoord) {
      runAction(hitWallSound)
      return
    }

    // update the position to the desired position...
    position = gameScene.tileMap.positionForTileCoord(toTileCoord)

    // ...and update the game state based on the cat's new position
    updateState()
  }

  /** Updates the cat's state for the current position. Returns <code>true</code> if the game ends */
  private func updateState() -> Bool {
    let currentTileCoord = gameScene.tileMap.tileCoordForPosition(position)

    if gameScene.isBoneAtTileCoord(currentTileCoord) {
      ++numBones
      gameScene.updateBoneCount(numBones)
      gameScene.removeObjectAtTileCoord(currentTileCoord)
      runAction(pickupBoneSound)

    } else if gameScene.isDogAtTileCoord(currentTileCoord) {
      if numBones == 0 {
        gameScene.loseGame()
        return true

      } else {
        --numBones
        gameScene.updateBoneCount(numBones)
        gameScene.removeObjectAtTileCoord(currentTileCoord)
        runAction(catAttackSound)
      }

    } else if gameScene.isExitAtTileCoord(currentTileCoord) {
      gameScene.winGame()
      return true

    } else {
      runAction(stepSound)
    }
    return false
  }

}

// Allow expressions such as let diff = point1 - point2
func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}
