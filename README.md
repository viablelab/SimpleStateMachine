# SimpleStateMachine

## Install

#### Carthage

```
github "viablelab/SimpleStateMachine"
```

## Usage

```swift
import SimpleStateMachine

enum State {
  case green
  case yellow
  case red
}

enum Action {
  case TIMER
}

var trafficLights = StateMachine<State, Action>(
  initial: .green,
  stateChart: [
    .green: [
      .TIMER: .yellow
    ],
    .yellow: [
      .TIMER: .red
    ],
    .red: [
      .TIMER: .green
    ]
  ]
)

trafficLights.onTransition({ (_ newState: State, _ oldState: State) in
  print("Light changed from `\(oldState)` to `\(newState)`")
})

Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { timer in
  trafficLights.send(.TIMER)
})
```
