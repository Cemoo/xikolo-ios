//
//  Future+retry.swift
//  xikolo-ios
//
//  Created by Max Bothe on 20.12.17.
//  Copyright © 2017 HPI. All rights reserved.
//

import BrightFutures

func retry<T,E>(_ context: @escaping ExecutionContext = DefaultThreadingModel(),
                times: Int,
                coolDown: DispatchTimeInterval,
                coolDownRate: @escaping (DispatchTimeInterval) -> DispatchTimeInterval = { rate in return rate },
                task: @escaping () -> Future<T,E>) -> Future<T,E> {
    let future = task()

    guard times > 1 else {
        return future
    }

    return future.recoverWith(context: context) { error in
        return Future(value: ()).delay(coolDown).flatMap { _ in
            return retry(context, times: times - 1, coolDown: coolDownRate(coolDown), coolDownRate: coolDownRate, task: task)
        }
    }
}
