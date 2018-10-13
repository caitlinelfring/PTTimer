//
//  PTTimerCountDown.swift
//  PTTimer
//
//  Created by Caitlin on 10/14/18.
//  Copyright © 2018 Caitlin Elfring. All rights reserved.
//

import Foundation

extension PTTimer {
  open class Down: PTTimer {
    private var startSeconds: Int

    public override init(initialTime: Int) {
      self.startSeconds = initialTime
      super.init(initialTime: initialTime)
    }

    override open func elapsedTimeDidChange(elapsed: TimeInterval) -> Int {
      let current = self.startSeconds - Int(elapsed)
      if current <= 0 {
        self.pause()
      }
      return current
    }
  }
}
