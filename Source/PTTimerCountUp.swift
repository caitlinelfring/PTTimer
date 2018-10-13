//
//  PTTimerCountUp.swift
//  PTTimer
//
//  Created by Caitlin on 10/14/18.
//  Copyright © 2018 Caitlin Elfring. All rights reserved.
//

import Foundation

extension PTTimer {
  open class Up: PTTimer {
    /// Timer will automatically pause after this time has elapsed
    public let maxSeconds: Int

    public init(maxSeconds: Int = 90 * 60) {
      self.maxSeconds = maxSeconds
    }

    override open func elapsedTimeDidChange(elapsed: TimeInterval) -> Int {
      if Int(elapsed) >= self.maxSeconds {
        self.pause()
      }
      return Int(elapsed)
    }
  }
}
