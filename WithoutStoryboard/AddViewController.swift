//
//  AddTableViewController.swift
//  WithoutStoryboard
//
//  Created by Yury on 24/03/2023.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func saveContact(contactName: String)
}

class AddViewController: UIViewController {
    
    // MARK: Properties
    private lazy var nameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Add new contact"
        name.borderStyle = .roundedRect
        name.clearButtonMode = .whileEditing
        name.addTarget(self, action: #selector(buttonState), for: .editingChanged)
        return name
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.layer.cornerRadius = 5
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemGray, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        saveButton.isEnabled = false
        return saveButton
    }()
    
    weak var delegate: AddViewControllerDelegate?
    
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        addSubviews()
        setupConstraints()
        
        nameTextField.delegate = self
    }
}

extension AddViewController {
    // MARK: Subviews
    private func addSubviews() {
        view.addSubview(nameTextField)
        view.addSubview(saveButton)
    }
    
    // MARK: Constraints
    private func setupConstraints() {
        // Constraints for nameTextField
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            nameTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        // Constraints for saveButton
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    // MARK: Targets
    @objc private func save() {
        if let text = nameTextField.text, !text.isEmpty {
            delegate?.saveContact(contactName: text)
        }
        dismiss(animated: true)
    }
    
    @objc private func buttonState() {
        guard let text = nameTextField.text else { return }
        if text.isEmpty {
            saveButton.isEnabled = false
            saveButton.setTitleColor(.systemGray, for: .normal)
        }
        else {
            saveButton.isEnabled = true
            saveButton.setTitleColor(.systemBlue, for: .normal)
        }
    }
    
}

// MARK: TextField Delegate
extension AddViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
