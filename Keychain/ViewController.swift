//
//  ViewController.swift
//  Keychain
//
//  Created by Aleksey Libin on 19.01.2023.
//

import UIKit
import Security

class ViewController: UIViewController {

    private let greetingLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @objc private func loginButtonPressed() {
        let alertController = UIAlertController(title: "Login", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Login" }
        alertController.addTextField { $0.placeholder = "Password" }

        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            guard
                let account = alertController.textFields?[0].text,
                let password = alertController.textFields?[1].text,
                KeychainManager.checkPass(password, by: account)
            else {
                print("error")
                return
            }
            print("success")
            self.navigationController?.viewControllers = [SecondViewController(name: account)]
        }

        alertController.addAction(submit)
        present(alertController, animated: true)
    }

    @objc private func registerButtonPressed() {
        let alertController = UIAlertController(title: "Register", message: "", preferredStyle: .alert)
        alertController.addTextField { $0.placeholder = "Login" }
        alertController.addTextField { $0.placeholder = "Password" }
        alertController.addTextField { $0.placeholder = "Confirm password" }

        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            guard
                let account = alertController.textFields?[0].text,
                let password = alertController.textFields?[1].text,
                alertController.textFields?[1].text == alertController.textFields?[2].text
            else { return }

            do {
                try KeychainManager.save(account: account, password: password.data(using: .utf8) ?? Data())
            } catch {
                print(error)
                return
            }
            self.navigationController?.viewControllers = [SecondViewController(name: account)]
        }

        alertController.addAction(submit)
        present(alertController, animated: true)
    }
}

// MARK: - Setup views
private extension ViewController {
    func setupViews() {
        view.backgroundColor = .white

        greetingLabel.text = "You are out of system \n you can log into existing account \n or create a new one"
        greetingLabel.textAlignment = .center
        greetingLabel.numberOfLines = 0
        greetingLabel.font = .boldSystemFont(ofSize: 20)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(greetingLabel)

        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .systemRed
        registerButton.layer.cornerRadius = 20
        registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        view.addSubview(registerButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            greetingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),

            loginButton.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 300),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 50),
            registerButton.heightAnchor.constraint(equalToConstant: 60),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
