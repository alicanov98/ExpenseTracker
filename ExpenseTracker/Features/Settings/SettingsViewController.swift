//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 02.08.26.
//

import UIKit
import SnapKit

protocol SettingsViewControllerDelegate: AnyObject {
    func settingsViewControllerDidLogout(
        _ controller: SettingsViewController
    )
}

final class SettingsViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: SettingsViewModelProtocol

    weak var delegate: SettingsViewControllerDelegate?

    // MARK: - UI Components

    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 36
        view.clipsToBounds = true
        return view
    }()

    private let initialLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .label
        return label
    }()

    private let themeSwitch = UISwitch()

    private let themeContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 14
        return view
    }()

    private let logoutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Logout"
        configuration.baseBackgroundColor = .systemRed
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .large
        return UIButton(configuration: configuration)
    }()

    // MARK: - Stack Views

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                avatarView,
                usernameLabel
            ]
        )
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var themeStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                themeLabel,
                themeSwitch
            ]
        )
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    // MARK: - Initialization

    init(viewModel: SettingsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAppearance()
        configureActions()
        configureHierarchy()
        configureConstraints()
        bindViewModel()
        loadData()
    }

    // MARK: - Configuration

    private func configureAppearance() {
        title = "Settings"
        view.backgroundColor = .systemBackground
    }

    private func configureActions() {
        themeSwitch.addTarget(
            self,
            action: #selector(themeSwitchChanged),
            for: .valueChanged
        )

        logoutButton.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )
    }

    private func configureHierarchy() {
        avatarView.addSubview(initialLabel)
        themeContainerView.addSubview(themeStackView)

        view.addSubview(profileStackView)
        view.addSubview(themeContainerView)
        view.addSubview(logoutButton)
    }

    private func configureConstraints() {
        avatarView.snp.makeConstraints { make in
            make.size.equalTo(72)
        }

        initialLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileStackView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            ).offset(28)

            make.leading.trailing.equalToSuperview().inset(24)
        }

        themeContainerView.snp.makeConstraints { make in
            make.top.equalTo(
                profileStackView.snp.bottom
            ).offset(36)

            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(64)
        }

        themeStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        logoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)

            make.bottom.equalTo(
                view.safeAreaLayoutGuide.snp.bottom
            ).offset(-24)

            make.height.equalTo(52)
        }
    }

    // MARK: - Binding

    private func bindViewModel() {
        viewModel.onThemeChanged = { [weak self] isDarkModeEnabled in
            self?.view.window?.overrideUserInterfaceStyle =
                isDarkModeEnabled ? .dark : .light
        }

        viewModel.onLogoutSuccess = { [weak self] in
            guard let self else { return }

            self.delegate?.settingsViewControllerDidLogout(self)
        }

        viewModel.onError = { [weak self] message in
            self?.showAlert(
                title: "Xəta",
                message: message
            )
        }
    }

    // MARK: - Data

    private func loadData() {
        usernameLabel.text = viewModel.username
        initialLabel.text = viewModel.usernameInitial
        themeSwitch.isOn = viewModel.isDarkModeEnabled
    }

    // MARK: - Actions

    @objc
    private func themeSwitchChanged() {
        viewModel.updateDarkMode(
            isEnabled: themeSwitch.isOn
        )
    }

    @objc
    private func logoutButtonTapped() {
        viewModel.logout()
    }
}
