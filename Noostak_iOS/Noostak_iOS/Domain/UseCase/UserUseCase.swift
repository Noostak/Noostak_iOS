//
//  UserUseCase.swift
//  Noostak_iOS
//
//  Created by 박민서 on 2/20/25.
//

import RxSwift

protocol UserUseCaseProtocol {
    func validate(name: String) -> Observable<ValidationResult>
}

final class UserUseCase: UserUseCaseProtocol {
    func validate(name: String) -> Observable<ValidationResult> {
        return Observable.just(SignUpValidator.validate(name: name))
    }
}
