//
//  ExpensesTableViewCell.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit
import SnapKit

class ExpensesTableViewCell: UITableViewCell {
  
    static let identifier = String(describing: ExpensesTableViewCell.self)
   
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let categoryLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
     
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGreen
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var leftStackView: UIStackView = {
       let stackView = UIStackView(
        arrangedSubviews: [titleLabel,categoryLabel]
       )
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill

        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                leftStackView,
                rightStackView
            ]
        )

        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fill

        return stackView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI(){
        selectionStyle = .none
        backgroundColor = .clear
        
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        addSubViews()
        addConstraints()
        
    }
    
    private func addSubViews(){
        contentView.addSubview(mainStackView)
    }
    
    private func addConstraints(){
        mainStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configure(with expense: Expense){
        titleLabel.text = expense.title
        categoryLabel.text = expense.category
        
        amountLabel.text = expense.amount.formatted(
            .currency(code: "AZN")
        )
        
        amountLabel.textColor = expense.amount < 0
        ? .systemRed
        : .systemGreen
        
        dateLabel.text = expense.createdAt.formatted(
            date: .abbreviated,
            time: .omitted
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        categoryLabel.text = nil
        amountLabel.text = nil
        dateLabel.text = nil
    }
}
