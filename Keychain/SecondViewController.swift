//
//  SecondViewController.swift
//  Keychain
//
//  Created by Aleksey Libin on 20.01.2023.
//

import UIKit

class SecondViewController: UIViewController {

    private let greetingLabel = UILabel()
    private let logOutButton = UIButton(type: .system)
    private let name: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    init(name: String) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func logOutButtonPressed() {
        navigationController?.viewControllers = [ViewController()]
    }
}

// MARK: - Setup views
private extension SecondViewController {

    func setupViews() {
        view.backgroundColor = .gray
        greetingLabel.text = "You are logged in as \(name ?? "")"
        greetingLabel.font = .systemFont(ofSize: 25)
        greetingLabel.numberOfLines = 0
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetingLabel)
        logOutButton.setTitle("Log out", for: .normal)
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.backgroundColor = .red
        logOutButton.layer.cornerRadius = 20
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 60),
            logOutButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
}
