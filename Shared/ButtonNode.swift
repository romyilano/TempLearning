//
//  ButtonNode.swift
//  Cat Maze
//
//  Created by Gabriel Hauber on 22/04/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {

  // 1 - action to be invoked when the button is tapped/clicked on
  var action: ((ButtonNode) -> Void)?

  // 2
  var isSelected: Bool = false {
    didSet {
      alpha = isSelected ? 0.8 : 1
    }
  }

  private let textLabel: SKLabelNode


  // MARK: - Initialisers

  required init(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }

  // 3
  init(text: String, fontNamed fontName: String, fontSize: CGFloat, textColor: SKColor) {
    textLabel = SKLabelNode(fontNamed: fontName)
    textLabel.text = text
    textLabel.fontSize = fontSize
    textLabel.fontColor = textColor
    textLabel.verticalAlignmentMode = .Center
    var size = textLabel.frame.size
    size.width += 10
    size.height += 10
    super.init(texture: nil, color: SKColor.clearColor(), size: size)
    userInteractionEnabled = true
    addChild(textLabel)
  }

  // MARK: - Cross-platform user interaction handling

  // 4
  override func userInteractionBegan(event: CCUIEvent) {
    isSelected = true
  }

  // 5
  override func userInteractionContinued(event: CCUIEvent) {
    let location = event.locationInNode(parent)

    if CGRectContainsPoint(frame, location) {
      isSelected = true
    } else {
      isSelected = false
    }
  }

  // 6
  override func userInteractionEnded(event: CCUIEvent) {
    isSelected = false

    let location = event.locationInNode(parent)

    if CGRectContainsPoint(frame, location) {
      // 7
      action?(self)
    }
  }
}
