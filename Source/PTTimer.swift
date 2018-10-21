//
//  PTTimer.swift
//  PTTimer
//
//  Created by Caitlin Elfring on 10/13/18.
//  Copyright © 2018 Caitlin Elfring. All rights reserved.
//

import Foundation

@objc public protocol PTTimerDelegate: class {
  @objc optional func timerTimeDidChange(seconds: Int)
  @objc optional func timerDidPause()
  @objc optional func timerDidStart()
  @objc optional func timerDidReset()
}

public enum PTTimerType: String {
  case up = "Up"
  case down = "Down"

  public static var available: [PTTimerType] {
    return [.up, .down]
  }
}

open class PTTimer {
  private var timer: Timer?
  private var startTime: TimeInterval!
  private let startSeconds: Int
  private var elapsedTime = TimeInterval()

  open weak var delegate: PTTimerDelegate?

  init(startSeconds: Int = 0) {
    self.startSeconds = startSeconds
  }

  private var currentSeconds: Int = 0 {
    didSet {
      if oldValue != self.currentSeconds {
        self.delegate?.timerTimeDidChange?(seconds: self.currentSeconds)
      }
    }
  }

  /// Current PTTimer.State of the timer
  open var state: State {
    if self.timer != nil {
      return .running
    }
    return self.elapsedTime > 0 ? .paused : .reset
  }

  /// Override this function and return the new currentSeconds value
  open func elapsedTimeDidChange(elapsed: TimeInterval) -> Int {
    fatalError("elapsedTimeDidChange must be overridden in the subclass")
  }

  @objc private func timerBlock(_ timer: Timer) {
    let currentTime = Date.timeIntervalSinceReferenceDate
    self.elapsedTime = currentTime - self.startTime
    self.currentSeconds = self.elapsedTimeDidChange(elapsed: self.elapsedTime)
  }

  /// Number of seconds that the timer is currently at
  open func seconds() -> Int {
    return self.currentSeconds
  }

  /// Start the timer
  open func start() {
    if self.timer != nil {
      // TODO: Throw error? Can't start an already started timer
      return
    }
    self.startTime = Date.timeIntervalSinceReferenceDate - TimeInterval(self.elapsedTime)
    if #available(iOS 10.0, *) {
      self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: self.timerBlock)
    } else {
      // Fallback on earlier versions
      self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerBlock), userInfo: nil, repeats: true)
    }
    self.delegate?.timerDidStart?()
  }

  /// Pause the timer
  open func pause() {
    self.invalidate()
    self.delegate?.timerDidPause?()
  }

  /// Reset the timer back to its initial state. Override this to customize the timer's initial state.
  open func reset() {
    self.startTime = nil
    self.elapsedTime = 0
    self.invalidate()
    self.currentSeconds = self.startSeconds
    self.delegate?.timerDidReset?()
  }

  private func invalidate() {
    self.timer?.invalidate()
    self.timer = nil
  }
}

extension PTTimer {
  public enum State: String {
    case paused
    case running
    case reset
  }
}
