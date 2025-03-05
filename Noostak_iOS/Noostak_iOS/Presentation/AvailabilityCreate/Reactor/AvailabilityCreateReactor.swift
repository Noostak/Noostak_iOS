//
//  AvailabilityCreateReactor.swift
//  Noostak_iOS
//
//  Created by 오연서 on 2/26/25.
//

import UIKit
import ReactorKit

final class AvailabilityCreateReactor: Reactor {
    enum Action {
        case selectCell(IndexPath)
        case tapConfirmAvailableTimes
    }
    
    enum Mutation {
        case toggleCell(IndexPath)
        case setAvailableTimes([AvailableTime])
    }
    
    struct State {
        var selectedCells: Set<IndexPath> = []
        var availableTimes: [AvailableTime] = []
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .selectCell(let indexPath):
            return .just(.toggleCell(indexPath))
            
        case .tapConfirmAvailableTimes:
            let selectedCells = currentState.selectedCells
            let selectedDateTimes = NSTDateUtility.selectedCellsToDateTime(
                selectedCells: selectedCells,
                dateHeaders: NSTDateUtility.dateList(mockDateList),
                timeHeaders: NSTDateUtility.timeList(mockStartTime, mockEndTime),
                originalDateList: mockDateList
            )
            print(selectedDateTimes)
            
            let availableTimes = selectedDateTimes.map { dateTime -> AvailableTime in
                return AvailableTime(date: dateTime, startTime: dateTime, endTime: dateTime)
            }
            return .just(.setAvailableTimes(availableTimes))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .toggleCell(let indexPath):
            newState.selectedCells = newState.selectedCells.symmetricDifference([indexPath])
            
        case .setAvailableTimes(let availableTimes):
            newState.availableTimes = availableTimes
        }
        return newState
    }
}

struct AvailableTime: Codable {
    let date: String
    let startTime: String
    let endTime: String
}
