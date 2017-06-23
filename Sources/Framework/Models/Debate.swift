//
//  Debate.swift
//  ELDebate
//
//  Created by Pawel Urbanek on 11/05/2017.
//  Copyright © 2017 EL Passion. All rights reserved.
//

import Foundation

struct Debate {

    let topic: String
    let positiveAnswer: Answer
    let neutralAnswer: Answer
    let negativeAnswer: Answer
    let lastAnswerIdentifier: Int?

}

extension Debate {

    public var lastAnswerType: AnswerType? {
        let answers: [Answer] = [positiveAnswer, neutralAnswer, negativeAnswer]
        return answers.first(where: { $0.identifier == lastAnswerIdentifier })?.type
    }

}