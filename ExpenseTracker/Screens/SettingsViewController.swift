//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Malik Alijanov on 30.07.26.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    // MARK: - UI Components

    private let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        return view
    }()

    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 30,
            weight: .bold
        )
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        return label
    }()

    private let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.font = .systemFont(ofSize: 17)
        return label
    }()

    private lazy var darkModeSwitch: UISwitch = {
        let switchControl = UISwitch()

        switchControl.isOn =
            ThemeManager.shared.isDarkModeEnabled

        switchControl.addTarget(
            self,
            action: #selector(darkModeValueChanged),
            for: .valueChanged
        )

        return switchControl
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)

        var configuration = UIButton.Configuration.filled()
        configuration.title = "Logout"
        configuration.baseBackgroundColor = .systemRed
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium

        button.configuration = configuration

        button.addTarget(
            self,
            action: #selector(logoutButtonTapped),
            for: .touchUpInside
        )

        return button
    }()

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

        return stackView
    }()

    private lazy var darkModeStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                darkModeLabel,
                darkModeSwitch
            ]
        )

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        return stackView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureProfile()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .systemBackground

        avatarView.addSubview(avatarLabel)

        view.addSubview(profileStackView)
        view.addSubview(darkModeStackView)
        view.addSubview(logoutButton)

        avatarView.snp.makeConstraints { make in
            make.size.equalTo(70)
        }

        avatarLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileStackView.snp.makeConstraints { make in
            make.top.equalTo(
                view.safeAreaLayoutGuide.snp.top
            ).offset(32)

            make.horizontalEdges.equalToSuperview().inset(20)
        }

        darkModeStackView.snp.makeConstraints { make in
            make.top.equalTo(
                profileStackView.snp.bottom
            ).offset(40)

            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }

        logoutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(
                view.safeAreaLayoutGuide.snp.bottom
            ).inset(24)

            make.height.equalTo(52)
        }
    }

    // MARK: - Configure Profile

    private func configureProfile() {
        let username = UserDefaults.standard.string(
            forKey: "username"
        ) ?? "User"

        usernameLabel.text = username

        avatarLabel.text = username
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .first
            .map { String($0).uppercased() } ?? "U"
    }

    // MARK: - Actions

    @objc
    private func darkModeValueChanged() {
        ThemeManager.shared.isDarkModeEnabled =
            darkModeSwitch.isOn

        guard let window = view.window else {
            return
        }

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve
        ) {
            ThemeManager.shared.applyTheme(to: window)
        }
    }

    @objc
    private func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Hesabdan çıxmaq istədiyinizə əminsiniz?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "Ləğv et",
                style: .cancel
            )
        )

        alert.addAction(
            UIAlertAction(
                title: "Çıxış",
                style: .destructive
            ) { _ in
                self.performLogout()
            }
        )

        present(alert, animated: true)
    }

    private func performLogout() {
        let tokenDeleted =
            KeychainManager.shared.deleteToken()

        guard tokenDeleted else {
            showAlert(
                title: "Xəta",
                message: "Token silinmədi."
            )
            return
        }

        UserDefaults.standard.removeObject(
            forKey: "username"
        )

        AppRouter.showLogin()
    }

    // MARK: - Alert

    private func showAlert(
        title: String,
        message: String
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )

        present(alert, animated: true)
    }
}
