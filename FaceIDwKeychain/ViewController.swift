//
//  ViewController.swift
//  FaceIDwKeychain
//
//  Created by Harun Demirkaya on 15.05.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: -Define
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please Enter a Word"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a Word"
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var buttonEncrypt: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Encrypt", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonEncryptTarget), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonDecrypt: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Decrypt", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(buttonDecryptTarget), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelDecryptedText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    // MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: -Functions
    private func setupViews(){
        view.backgroundColor = .black
        
        textField.textFieldConstraints(view)
        labelTitle.labelTitleConstraints(view, textField: textField)
        buttonEncrypt.buttonEncryptConstraints(view, textField: textField)
        buttonDecrypt.buttonDecryptConstraints(view, button: buttonEncrypt)
        labelDecryptedText.labelDecryptedTextConstraints(view, button: buttonDecrypt)
        
        let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(endEditingGesture)
    }
    
    @objc private func buttonEncryptTarget(){
        if let text = textField.text, textField.text != ""{
            Keychain.save(key: "encryptedText", data: text)
        }
    }
    
    @objc private func buttonDecryptTarget(){
        BiometricAuthentication.authenticateWithBiometricAuthentication { result in
            switch result{
            case .failed:
                self.labelDecryptedText.text = "Failed"
            case .notSupported:
                self.labelDecryptedText.text = "Not Supported"
            case .success:
                self.labelDecryptedText.text = Keychain.load(key: "encryptedText")
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

private extension UIView{
    func textFieldConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func labelTitleConstraints(_ view: UIView, textField: UITextField){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -20).isActive = true
    }
    
    func buttonEncryptConstraints(_ view: UIView, textField: UITextField){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20).isActive = true
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func buttonDecryptConstraints(_ view: UIView, button: UIButton){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        widthAnchor.constraint(equalToConstant: 300).isActive = true
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func labelDecryptedTextConstraints(_ view: UIView, button: UIButton){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
    }
}
