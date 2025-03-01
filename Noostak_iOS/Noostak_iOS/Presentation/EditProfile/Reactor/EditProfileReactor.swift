//
//  EditProfileReactor.swift
//  Noostak_iOS
//
//  Created by 박민서 on 3/1/25.
//

import Foundation
import RxSwift
import ReactorKit

final class EditProfileReactor: Reactor {
    enum Action {
        case selectImage(Data?)
        case inputName(String)
        case tapNameDeleteButton
    }
    
    enum Mutation {
        case setImage(Data?)
        case setName(String)
        case setValidationResult(ValidationResult)
    }
    
    struct State {
        var newProfileImageData: Data?
        var currentProfileImageURL: String?
        var name: String
        var nameTextFieldState: TextFieldState = .valid
        var validationMessage: String = ""
        var isConfirmButtonEnabled: Bool = false
    }
    
    let initialState: State
    private let userUseCase: UserUseCaseProtocol

    init(initialState: State, userUseCase: UserUseCaseProtocol) {
        self.initialState = initialState
        self.userUseCase = userUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectImage(data):
            return Observable.just(.setImage(data))
            
        case let .inputName(name):
            guard name != currentState.name else { return .empty() }
            return Observable.concat([
                Observable.just(.setName(name)),
                userUseCase.validate(name: name)
                    .map { .setValidationResult($0) }
            ]).observe(on: MainScheduler.asyncInstance)
            
        case .tapNameDeleteButton:
            return Observable.concat([
                Observable.just(.setName("")),
                Observable.just(.setValidationResult(.valid))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setImage(data):
            newState.newProfileImageData = data
            
        case let .setName(name):
            newState.name = name

        case let .setValidationResult(result):
            switch result {
            case .valid:
                newState.nameTextFieldState = .valid
                newState.isConfirmButtonEnabled = state.name.isEmpty ? false : true
            case let .invalid(reason):
                newState.nameTextFieldState = .invalid(reason)
                newState.isConfirmButtonEnabled = false
            }
        }

        return newState
    }
}
