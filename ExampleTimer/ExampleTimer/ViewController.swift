//
//  ViewController.swift
//  ExampleTimer
//
//  Created by Caitlin Elfring on 10/13/18.
//  Copyright © 2018 Caitlin Elfring. All rights reserved.
//

import UIKit
import PTTimer

class ViewController: UIViewController {
  let label = UILabel()
  var timer: PTTimer!

  let timerTypeControl = UISegmentedControl(items: PTTimerType.available.map { $0.rawValue })

  let start = UIButton(type: .system)
  let pause = UIButton(type: .system)
  let reset = UIButton(type: .system)
  let changeTime = UIButton(type: .system)

  var timerSeconds: Int = ViewController.defaultTimerSeconds
  static let defaultTimerSeconds: Int = 5

  var currentTimerType: PTTimerType = PTTimerType.available[0]

  override func viewDidLoad() {
    super.viewDidLoad()

    self.label.adjustsFontSizeToFitWidth = true
    self.label.textAlignment = .center
    self.label.textColor = .black
    self.label.font = UIFont(name: "HelveticaNeue-Medium", size: 40)! // any monospace font would work

    self.view.addSubview(self.label)
    self.label.translatesAutoresizingMaskIntoConstraints = false
    self.label.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    self.label.bottomAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.label.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

    self.start.setTitle("start", for: .normal)
    self.start.addTarget(self, action: #selector(self.didPressButton), for: .touchUpInside)
    self.pause.setTitle("pause", for: .normal)
    self.pause.isEnabled = false
    self.pause.addTarget(self, action: #selector(self.didPressButton), for: .touchUpInside)
    self.reset.setTitle("reset", for: .normal)
    self.reset.isEnabled = false
    self.reset.addTarget(self, action: #selector(self.didPressButton), for: .touchUpInside)
    self.timerTypeControl.addTarget(self, action: #selector(self.didChangeTimerType), for: .valueChanged)
    self.timerTypeControl.selectedSegmentIndex = 0
    self.updateCountTimer()

    self.changeTime.setTitle("change time", for: .normal)
    self.changeTime.addTarget(self, action: #selector(self.didPressButton), for: .touchUpInside)

    let buttonStack = UIStackView()
    buttonStack.alignment = .center
    buttonStack.axis = .vertical
    buttonStack.addArrangedSubview(self.start)
    buttonStack.addArrangedSubview(self.pause)
    buttonStack.addArrangedSubview(self.reset)
    buttonStack.addArrangedSubview(self.timerTypeControl)
    buttonStack.addArrangedSubview(self.changeTime)
    self.view.addSubview(buttonStack)
    buttonStack.translatesAutoresizingMaskIntoConstraints = false
    buttonStack.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    buttonStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    buttonStack.topAnchor.constraint(equalTo: self.label.bottomAnchor).isActive = true
  }

  func setTime(seconds: Int) {
    let attributedText = NSAttributedString(string:  ViewController.formatTime(seconds: seconds), attributes: [NSAttributedString.Key.kern: 5])
    self.label.attributedText = attributedText
  }

  class func formatTime(seconds: Int) -> String {
    let minutesValue =  seconds % (1000 * 60) / 60
    let secondsValue = seconds % 60
    return String(format: "%02d:%02d", minutesValue, secondsValue)
  }

  func updateCountTimer() {
    if self.timer != nil {
      self.timer.delegate = nil
      self.timer = nil
    }

    if self.currentTimerType == .down {
      self.timer = PTTimer.Down(initialTime: self.timerSeconds)
    } else {
      self.timer = PTTimer.Up(maxSeconds: self.timerSeconds)
    }
    self.timer.delegate = self
    self.timer.reset()
    self.setTime(seconds: self.timer.seconds())
  }

  @objc private func didChangeTimerType(sender: UISegmentedControl) {
    self.currentTimerType = PTTimerType(rawValue: PTTimerType.available[sender.selectedSegmentIndex].rawValue)!
    self.updateCountTimer()
  }

  @objc private func didPressButton(sender: UIButton) {
    guard let title = sender.currentTitle?.lowercased() else { return }
    switch title {
    case "start": self.timer.start()
    case "pause": self.timer.pause()
    case "reset": self.timer.reset()
    case "change time":
      let alert = UIAlertController(title: "Change Time", message: "Number of seconds for timer", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
        guard let seconds = alert.textFields?[0].text else { return }
        self.timerSeconds = Int(seconds) ?? ViewController.defaultTimerSeconds
        self.updateCountTimer()
      }))
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

      alert.addTextField { (textField) in
        textField.keyboardType = .numberPad
        textField.clearsOnBeginEditing = true
        textField.text = String(self.timerSeconds)
      }
      self.present(alert, animated: true, completion: nil)
    default: fatalError("unknown button with title: \(title)")
    }
  }
}

extension ViewController: PTTimerDelegate {
  func timerTimeDidChange(seconds: Int) {
    self.setTime(seconds: seconds)
  }

  func timerDidPause() {
    self.label.textColor = .orange
    self.pause.isEnabled = false
    self.start.isEnabled = true
    self.reset.isEnabled = true
    self.timerTypeControl.isEnabled = false
    self.changeTime.isEnabled = false
  }

  func timerDidStart() {
    self.label.textColor = .green
    self.pause.isEnabled = true
    self.start.isEnabled = false
    self.reset.isEnabled = false
    self.timerTypeControl.isEnabled = false
    self.changeTime.isEnabled = false
  }

  func timerDidReset() {
    self.label.textColor = .black
    self.pause.isEnabled = false
    self.start.isEnabled = true
    self.reset.isEnabled = false
    self.timerTypeControl.isEnabled = true
    self.changeTime.isEnabled = true
  }
}
