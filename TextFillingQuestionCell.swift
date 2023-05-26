//
//  TextFillingQuestionCell.swift
//  Questionnaire
//
//  Created by Roman on 25/05/2023.
//

import UIKit

/// Question cell outpud
protocol QuestionCellOutput: AnyObject {

	/// answer received for question
	/// - Parameters:
	///   - questionUUID: question UUID
	///   - answer: answer string
	func answerFor(questionUUID: UUID, answer: String)
}

/// Cell for question where user has to put his oun answer
final class TextFillingQuestionCell: UITableViewCell, RKTableViewCellProtocol {

	var shouldReuse = false

	private let output: QuestionCellOutput?
	private let questionUUID: UUID

	private let questionLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 3
		return label
	}()

	private var underView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 10
		return view
	}()

	private var textFillingUnderlineView: UIView = {
		let view = UIView()
		view.backgroundColor = .blue
		return view
	}()

	private var textField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.autocorrectionType = .no
		return textField
	}()

	private enum Sizes {
		static let verticalIndent: CGFloat = 10
		static let underlineHeight: CGFloat = 1
		static let contentToBottom: CGFloat = 30
		static let textFieldHeight: CGFloat = 20
		static let horizontalIndent: CGFloat = 15
		static let textFieldToUnderline: CGFloat = 5
		static let verticalUnderViewInden: CGFloat = 10
		static let underViewHorizontalIndent: CGFloat = 20
	}

	/// Initializer
	/// - Parameters:
	///   - questionUUID: question UUID
	///   - text: question text
	///   - placeholder: placeholer
	///   - output: object for reacting on user interactions
	init(questionUUID: UUID, text: String, placeholder: String?, output: QuestionCellOutput?) {
		self.output = output
		self.questionUUID = questionUUID
		super.init(style: .subtitle, reuseIdentifier: nil)
		setupUI(text: text, placeholder: placeholder)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private

	private func setupUI(text: String, placeholder: String?) {
		selectionStyle = .none
		textField.delegate = self
		backgroundColor = .clear

		questionLabel.text = text
		if let placeholder = placeholder {
			let attributes = [NSAttributedString.Key.foregroundColor: UIColor.orange,
							  .font: UIFont.systemFont(ofSize: 14)]
		 textField.attributedPlaceholder = NSAttributedString(string: placeholder,  attributes: attributes)
		}

	}

	private func setupConstraints() {
		contentView.addSubview(underView)
		contentView.addSubview(questionLabel)
		contentView.addSubview(textField)
		contentView.addSubview(textFillingUnderlineView)

		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			underView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizes.verticalUnderViewInden),
			underView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Sizes.verticalUnderViewInden),
			underView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizes.underViewHorizontalIndent),
			underView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Sizes.underViewHorizontalIndent),

			questionLabel.topAnchor.constraint(equalTo: underView.topAnchor, constant: Sizes.verticalIndent),
			questionLabel.leadingAnchor.constraint(equalTo: underView.leadingAnchor, constant: Sizes.horizontalIndent),
			questionLabel.trailingAnchor.constraint(equalTo: underView.trailingAnchor, constant: -Sizes.horizontalIndent),
			
			textField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Sizes.verticalIndent),
			textField.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
			textField.heightAnchor.constraint(equalToConstant: Sizes.textFieldHeight),
			
			textFillingUnderlineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: Sizes.textFieldToUnderline),
			textFillingUnderlineView.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
			textFillingUnderlineView.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
			textFillingUnderlineView.heightAnchor.constraint(equalToConstant: Sizes.underlineHeight),
			textFillingUnderlineView.bottomAnchor.constraint(equalTo: underView.bottomAnchor, constant: -Sizes.contentToBottom),
		])
	}

	// MARK: - RKTableViewCellProtocol

	func didSelected() {}

	func selectedToBeEdited() {}

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}

	func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {}
}

extension TextFillingQuestionCell: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textChanged(in: textField)
		return false
	}

	func textFieldDidChangeSelection(_ textField: UITextField) {
		textChanged(in: textField)
	}

	// MARK: Private

	private func textChanged(in textField: UITextField) {
		guard let answer = textField.text,
			  !answer.isEmpty else { return }

		output?.answerFor(questionUUID: questionUUID, answer: answer)
	}
}
