//
//  ExpenseTableViewCell.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit
import SnapKit

final class ExpenseTableViewCell: UITableViewCell {

    // MARK: - Identifier

    static let identifier = String(
        describing: ExpenseTableViewCell.self
    )

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .semibold
        )
        label.textColor = .label
        return label
    }()

    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )
        label.textColor = .systemBlue
        label.textAlignment = .right
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()

    private lazy var leftStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                categoryLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 5

        return stackView
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                amountLabel,
                dateLabel
            ]
        )

        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .trailing

        return stackView
    }()

    // MARK: - Initializer

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground

        contentView.addSubview(leftStackView)
        contentView.addSubview(rightStackView)

        leftStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(
                rightStackView.snp.leading
            ).offset(-12)
        }

        rightStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    // MARK: - Configure

    func configure(with expense: Expense) {
        titleLabel.text = expense.title
        categoryLabel.text = expense.category
        amountLabel.text = String(
            format: "%.2f ₼",
            expense.amount
        )

        dateLabel.text = Self.dateFormatter.string(
            from: expense.createdAt
        )
    }

    // MARK: - Date Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }()
}
