//
//  LoginController.swift
//  Instagram
//
//  Created by Andrei Cojocaru on 03.08.2021.
//

import Foundation
import UIKit

protocol AutheticationDelegate: AnyObject {
    func autheticationDidComplete()
}

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    weak var delegate: AutheticationDelegate?
    
    private let iconImage : UIImageView =  {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustomTextField(placeholder: "email")
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
       
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustomTextField(placeholder: "password")
        tf.isSecureTextEntry  = true
       
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        button.layer.cornerRadius = 5
        button.setHeight(50)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        return button
    }()

    private let dontHaveAccount: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account? ", secondPart: "Sign up")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
        
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Help sign up")
        
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
 // MARK:  -  Actions
    
    @objc func handleLogIn() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("DEBUG: Faield to log user in \(error.localizedDescription)")
                return
            }
            self.delegate?.autheticationDidComplete()
            
        }
    }
    
    @objc func handleShowSignUp() {
        
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func texDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }else {
            viewModel.password = sender.text
        }
       updateform()
    }
    
    //MARK: - Configure UI
    
    func configureUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor,paddingTop: 32)
        
        let authenStack = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,loginButton,forgotPasswordButton])
        authenStack.axis = .vertical
        authenStack.spacing = 20
        authenStack.distribution = .fillEqually
        
        view.addSubview(authenStack)
        authenStack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor,
                           paddingTop: 32,paddingLeft: 32,paddingRight: 32)
        
        view.addSubview(dontHaveAccount)
        dontHaveAccount.centerX(inView: view)
        dontHaveAccount.anchor(bottom:view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(texDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(texDidChange), for: .editingChanged)
    }
    
}

// MARK: - Form View Model

extension LoginController: FormViewModel {
    func updateform() {
        
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

