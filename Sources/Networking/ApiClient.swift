//
//  ApiClient.swift
//  ELDebate
//
//  Created by Pawel Urbanek on 11/05/2017.
//  Copyright © 2017 EL Passion. All rights reserved.
//

import Foundation
import PromiseKit

protocol APIProviding {

    func login(pinCode: String) -> Promise<String>
    func fetchDebate(authToken: String) -> Promise<Debate>

}

class ApiClient: APIProviding {

    private let requestExecutor: RequestExecuting
    private let authTokenDeserializer: Deserializer<String>
    private let debateDeserializer: Deserializer<Debate>
    private let apiHost = "https://el-debate.herokuapp.com"

    init(requestExecutor: RequestExecuting,
         authTokenDeserializer: Deserializer<String>,
         debateDeserializer: Deserializer<Debate>) {
        self.requestExecutor = requestExecutor
        self.authTokenDeserializer = authTokenDeserializer
        self.debateDeserializer = debateDeserializer
    }

    func login(pinCode: String) -> Promise<String> {
        let jsonResponse = requestExecutor.post(
            url: "\(apiHost)/api/login", body: ["code": pinCode]
        )

        return Promise { fulfill, reject in
            jsonResponse.json { [weak self] jsonData in
                guard let `self` = self else { fatalError("This should never happen") }

                do {
                    let authToken = try self.authTokenDeserializer.deserialize(json: jsonData)
                    fulfill(authToken)
                } catch let error {
                    reject(error)
                }
            }
        }
    }

    func fetchDebate(authToken: String) -> Promise<Debate> {
        let jsonResponse =  requestExecutor.get(
            url: "\(apiHost)/api/debate", headers: ["Authorization": authToken]
        )

        return Promise { fulfill, reject in
            jsonResponse.json { [weak self] jsonData in
                guard let `self` = self else { fatalError("This should never happen") }
                do {
                    let debate = try self.debateDeserializer.deserialize(json: jsonData)
                    fulfill(debate)
                } catch let error {
                    reject(error)
                }
            }
        }
    }
}
