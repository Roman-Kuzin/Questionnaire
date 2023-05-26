//
//  Constants.swift
//  Questionnaire
//
//  Created by Roman on 26/05/2023.
//

import Foundation

struct Constants {

	static let serverUrl = URL(string: "http://127.0.0.1:3000/db")
	static let urlForAnswers = URL(string: "http://127.0.0.1:3000/answers")
	static let urlForQuestions = URL(string: "http://127.0.0.1:3000/questions")

	static let questions: [Question] = [
		Question(type: QuestionType.multipleChoice([.plain("Kotlin"),
													.plain("Java"),
													.plain("C++")]),
				 question: "What language is your favorite?",
				 isRequired: false),
		Question(type: .textFilling(placeHolder: "Your answer"),
				 question: "What do you like about programming?", isRequired: false),
		Question(type: .multipleChoice([.plain("Easy"),
										.plain("Normal"),
										.plain("Hard"),
										.textFilling(text: "Other", placeHolder: nil)]),
				 question: "How was the assignment?",
				 isRequired: true)
	]
}
