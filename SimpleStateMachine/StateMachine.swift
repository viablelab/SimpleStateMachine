//
//  SimpleStateMachine.swift
//  SimpleStateMachine
//
//  Created by Johan West on 2019-09-09.
//  Copyright © 2019 Viable lab AB. All rights reserved.
//

import Foundation

public struct StateMachine<State: Hashable, Action: Hashable> {
  public typealias StateChart = [State: [Action: State]]
  public typealias OnTransitionClosure = (_ newState: State, _ lastState: State) -> Void

  public let stateChart: StateChart
  public var currentState: State
  public var lastState: State

  private var onTransition: OnTransitionClosure?
  private var debugging = false

  public init(initial: State, stateChart: StateChart) {
    self.stateChart = stateChart
    currentState = initial
    lastState = initial
  }

  public mutating func send(_ action: Action) {
    let possibleActions = stateChart[currentState]
    let nextState = possibleActions?[action]

    if nextState != nil {
      lastState = currentState
      currentState = nextState!
      onTransition?(nextState!, lastState)
      perhapsPrintDebugMessage(forAction: action)
    } else {
      perhapsPrintDebugMessage(forAction: action, failed: true)
    }
  }

  public mutating func onTransition(_ onTransitionClosure: @escaping OnTransitionClosure) {
    onTransition = onTransitionClosure
  }

  public mutating func debug() {
    debugging = true
  }

  private func perhapsPrintDebugMessage(forAction: Action, failed: Bool = false) {
    if !debugging {
      return
    }

    print("\n=== STATE MACHINE TRANSITION ===")
    print("Action: \(forAction)")

    if failed {
      print("No possible transition from <\(currentState)> state")
    } else {
      print("Old state: \(lastState)")
      print("New state: \(currentState)")
    }

    print("================================")
  }
}
