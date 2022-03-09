//
//  LocalSearchClient.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-02-27.
//

import MapKit
import ComposableArchitecture

struct LocalSearchClient {
    //Search for a location using the Search Completion string
    var search: (MKLocalSearchCompletion) -> Effect<MKLocalSearch.Response, Error>
}

//Extend LocalSearchClient to include an async function to gather results
extension LocalSearchClient {
    static let live = Self (
        search: { completion in
                .task {
                    try await MKLocalSearch(request: .init(completion: completion))
                        .start()
                }
        }
    )
}

//Extend Effect to add a "task" function where any async work can be contained
extension Effect {
    static func task (
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Output
    ) -> Self
    where Failure == Error {
        .future { callback in
            
            //Task allows you to run async functions within it. Here, we search for locations
            Task(priority: priority) {
                do {
                    callback(.success(try await operation()))
                } catch {
                    callback(.failure(error))
                }
            }
        }
    }
}
