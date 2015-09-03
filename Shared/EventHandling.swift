//
//  EventHandling.swift
//  Cat Maze
//
//  Created by Gabriel Hauber on 22/04/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import SpriteKit

// MARK: - cross-platform object type aliases

#if os(iOS)
typealias CCUIEvent = UITouch
typealias CCTapOrClickGestureRecognizer = UITapGestureRecognizer
#else
typealias CCUIEvent = NSEvent
typealias CCTapOrClickGestureRecognizer = NSClickGestureRecognizer
import Carbon // for the OS X virtual key codes!
#endif

enum Direction {
  case Up, Down, Left, Right
}
// ideally this would be a struct, but swiftc does not allow overriding functions declared in extensions
// unless the declaration is fully Objective-C compatible
/** abstracting events from keyboards, etc */
@objc class ControllerEvent {
  let direction: Direction
  init(direction: Direction) {
    self.direction = direction
  }
}

extension SKNode {

  #if os(iOS)

  // MARK: - iOS Touch handling

  override public func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)  {
    userInteractionBegan(touches.first as! UITouch)
  }

  override public func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)  {
    userInteractionContinued(touches.first as! UITouch)
  }

  override public func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
    userInteractionEnded(touches.first as! UITouch)
  }

  override public func touchesCancelled(touches: Set<NSObject>, withEvent event: UIEvent) {
    userInteractionCancelled(touches.first as! UITouch)
  }

  #else

  // MARK: - OS X mouse event handling

  override public func mouseDown(event: NSEvent) {
    userInteractionBegan(event)
  }

  override public func mouseDragged(event: NSEvent) {
    userInteractionContinued(event)
  }

  override public func mouseUp(event: NSEvent) {
    userInteractionEnded(event)
  }

  public override func keyDown(theEvent: NSEvent) {
    switch Int(theEvent.keyCode) {
    case kVK_UpArrow: controllerEvent(ControllerEvent(direction: .Up))
    case kVK_LeftArrow: controllerEvent(ControllerEvent(direction: .Left))
    case kVK_RightArrow: controllerEvent(ControllerEvent(direction: .Right))
    case kVK_DownArrow: controllerEvent(ControllerEvent(direction: .Down))
    default: break // nothing
    }
  }

  #endif

  // MARK: - Cross-platform event handling

  func userInteractionBegan(event: CCUIEvent) {
  }

  func userInteractionContinued(event: CCUIEvent) {
  }

  func userInteractionEnded(event: CCUIEvent) {
  }

  func userInteractionCancelled(event: CCUIEvent) {
  }

  func controllerEvent(event: ControllerEvent) {
  }

}