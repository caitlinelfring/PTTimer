PTTimer - A Customizable Swift Timer Class
---

PTTimer is a Swift class that can be used to create timers that accurately track time.

**PTTimer** is an project that I originally created for an iOS
app I've been working on. I decided to extract it from my app and open-source it because I noticed that there wasn't really a good resource for Swift stopwatch/countdown timers available.

## Background

I was seeing blog posts that suggested using a simple counter to build the timer. This meant doing the following:

**DO NOT DO THIS!!!**
```swift
let seconds = 60
let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                selector: #selector(timerRunning),
                                userInfo: nil, repeats: true)

func timerRunning() {
  second -= 1
}
```

This is a **very bad** idea (as I learned the hard way) because Swift's `Timer` **doesn't fire when the app is in the background.** Therefore, when you return from the background and the `Timer` fires again, it starts off where it left. If the app was in the background for 30 seconds, your timer doesn't correct for that at all. This is a sure-fire way to get an inaccurate timer. What's the point then??

**PTTimer** uses `Timer` underneath, but the advantage of `PTTimer` is that it manages the timer clock for you. I found the best way to deal with app backgrounding was to use the system clock to manage the timer, which allows for self-correction when on the next `Timer` even is fired.

## Features
* No dependencies!
* Comes with two built-in timers:
  * a **CountUp** timer (starts at 0 and counts up)
  * a **CountDown** timer (starts at however many seconds you specify and counts down to 0)
* Continues keeping time **even when your app is in the background**
* Accurately counts time based on the device clock
* Subclass-able: Override methods on `PTTimer` to completely customize your timer.

## Installation

**PTTimer** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PTTimer'
```

## Usage

First, be sure to `import PTTimer`

##### Create a timer that counts down to `0` from an initial seconds.

```swift
// This creates a countdown timer that begins at 5 minutes
let timer = PTTimer.Down(initialTime: 60 * 5)
```

##### Create a timer that counts up from `0` to a max number of seconds
* (default `90*60` or 90 minutes)

```swift
let timer = PTTimer.Up()
// customize the maxSeconds
let timer = PTTimer.Up(maxSeconds: 60 * 15)
```

##### Interact with the timer
```swift
// start the timer
timer.start()

// pause the timers
timer.pause()

// reset the timer back to the original state
// (0 if count up, initialTime if count down)
timer.reset()

// read the state of the timer (.paused, .running, .reset)
let state = timer.state

// read the current seconds of the timer
let currentSeconds = timer.seconds()
```

Feel free to create your own timer by subclassing `PTTimer`

#### Delegate functions

Utilize the delegate to take actions when the timer state changes and when the timer's time changes
```swift
func timerTimeDidChange(seconds: Int) {
  // Update labels, buttons when the timer seconds have changed
  // consider a formatter to turn seconds into 00:00 or similar
}

func timerDidPause() {
  // update label colors, buttons for a paused timer
}

func timerDidStart() {
  // update label colors, buttons for a started timer
}

func timerDidReset() {
  // update label colors, buttons now that the timer has been reset
}
```

## Example App

Check out the `ExampleTimer` app for an example usage of `PTTimer`

From `ExampleTimer` directory, run `pod install`.

In XCode, open `ExampleTimer/ExampleTimer.xcworkspace` and run.

You can see UI code for the timer in `ExampleTimer/ExampleTimer/ViewController.swift`

## Contribute

Contributions are welcomed and encouraged! Anything that you believe will better this project, I'd love to hear. I reserve the right to accept or deny changes at my discretion.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create pull request

### Other information

GitHub Issues is for reporting bugs, discussing features and general feedback in **PTTimer**.
Be sure to check our [past issues](https://github.com/caitlin615/PTTimer/issues?state=closed) before opening any new issues.

If you are posting about a crash in your application, a stack trace is helpful, but additional context, in the form of code and explanation, is necessary to be of any use.


## License

**PTTimer** is available under the MIT license. See the [LICENSE](https://github.com/caitlin615/PTTimer/blob/master/LICENSE) file for more info.
