//
//  GameScene.swift
//  Cat Maze
//
//  Created by Matthijs on 19-06-14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

  let levelName: String
  let tileMap: TileMapNode
  let cat = Cat()

  // pre-load some sound effects
  let loseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
  let winSound = SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)

  // on-screen status labels
  let bonesLabel = ShadowedLabelNode(fontNamed: "GillSans-Bold", fontSize: 22, color: SKColor.whiteColor().colorWithAlphaComponent(0.9), shadowColor: SKColor.blackColor().colorWithAlphaComponent(0.9))

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder) is not used in this app")
  }

  init(size: CGSize, levelName: String) {
    self.levelName = levelName
    tileMap = TileMapNode(filename: levelName)!
    super.init(size: size)
    addChild(tileMap)
    cat.gameScene = self

    updateBoneCount(cat.numBones)
    bonesLabel.position = CGPoint(x: 20 + bonesLabel.size.width / 2, y: 20)
    addChild(bonesLabel)
  }

  func setViewportCenter(position: CGPoint) {
    var x = max(position.x, size.width / 2)
    var y = max(position.y, size.height / 2)
    x = min(x, tileMap.size.width - size.width / 2)
    y = min(y, tileMap.size.height - size.height / 2)
    let actualPosition = CGPoint(x: x, y: y)
    let centerOfView = CGPoint(x: size.width / 2, y: size.height / 2)
    let viewPoint = centerOfView - actualPosition
    tileMap.position = viewPoint
  }

  func spawnCat() {
    let spawnCoord = tileMap.playerSpawnTileCoord
    let spawnPos = tileMap.positionForTileCoord(spawnCoord)
    setViewportCenter(spawnPos)

    cat.position = spawnPos
    tileMap.addChild(cat)
  }

  override func controllerEvent(event: ControllerEvent) {
    cat.moveInDirection(event.direction)
  }

  override func userInteractionBegan(event: CCUIEvent) {
    cat.moveToward(event.locationInNode(tileMap))
  }

  override func update(currentTime: NSTimeInterval) {
    setViewportCenter(cat.position)
  }

  func isWalkableTileForTileCoord(tileCoord: TileCoord) -> Bool {
    return tileMap.isValidTileCoord(tileCoord) && !isWallAtTileCoord(tileCoord)
  }

  func isWallAtTileCoord(coord: TileCoord) -> Bool {
    return tileMap.layerNamed("Background", hasObjectNamed: "Wall", atCoord: coord)
  }

  func isBoneAtTileCoord(coord: TileCoord) -> Bool {
    return tileMap.layerNamed("Objects", hasObjectNamed: "Bone", atCoord: coord)
  }

  func isDogAtTileCoord(coord: TileCoord) -> Bool {
    return tileMap.layerNamed("Objects", hasObjectNamed: "DogDown1", atCoord: coord)
  }

  func isExitAtTileCoord(coord: TileCoord) -> Bool {
    return tileMap.layerNamed("Objects", hasObjectNamed: "Exit", atCoord: coord)
  }

  func removeObjectAtTileCoord(coord: TileCoord) {
    tileMap.layerNamed("Objects", removeObjectAtCoord: coord)
  }

  func updateBoneCount(numBones: Int) {
    bonesLabel.text = "Bones: \(numBones)"
  }

  func loseGame() {
    runAction(loseSound)
    endScene(won: false)
  }

  func winGame() {
    runAction(winSound)
    endScene(won: true)
  }

  private func endScene(#won: Bool) {
    cat.runAction(SKAction.sequence([
      SKAction.scaleBy(3, duration: 0.5),
      SKAction.waitForDuration(1.0),
      SKAction.scaleTo(0, duration: 0.5)
      ]),
      completion: { [weak self] in
        self?.showRestartMenu(won: won)
      })
    cat.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(2 * M_PI), duration: 0.5)), completion: nil)
  }

  private func showRestartMenu(#won: Bool) {
    let messageLabel = ShadowedLabelNode(fontNamed: "GillSans-Bold", fontSize: 48, color: SKColor.whiteColor(), shadowColor: SKColor.blackColor())
    messageLabel.text = won ? "You win!" : "You lose!"
    messageLabel.setScale(0.1)
    messageLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.6)
    addChild(messageLabel)

    let restartButton = ButtonNode(text: "Restart", fontNamed: "GillSans-Bold", fontSize: 32, textColor: SKColor.whiteColor())
    restartButton.action = { [weak self] (button) in
      self?.restartGame()
    }
    restartButton.setScale(0.1)
    restartButton.position = CGPoint(x: size.width / 2, y: size.height * 0.4)
    addChild(restartButton)

    messageLabel.runAction(SKAction.scaleTo(1.0, duration: 0.5), completion: nil)
    restartButton.runAction(SKAction.scaleTo(1.0, duration: 0.5), completion: nil)
  }

  private func restartGame() {
    // reload the current scene
    let scene = GameScene(size: size, levelName: levelName)
    scene.spawnCat()
    view?.presentScene(scene, transition: SKTransition.flipVerticalWithDuration(0.5))
  }
}
