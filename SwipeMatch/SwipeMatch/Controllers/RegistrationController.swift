//
//  RegistrationController.swift
//  SwipeMatch
//
//  Created by Александр Банников on 27.10.2020.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    
    //MARK: UI components
    
    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .disabled)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        //button.backgroundColor = #colorLiteral(red: 0.7772458196, green: 0.09371804446, blue: 0.323792249, alpha: 1)
        button.backgroundColor = .lightGray
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        
        setupNotificationsObservers()
        
        setupTapGesture()
        
        setupRegistrationViewModelObserver()
    }
    
    //MARK:- fileprivate
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton
    ])
    
    fileprivate func setupLayout() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    let gLayer = CAGradientLayer()
    
    fileprivate func setupGradientLayer() {
        let gLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 0.9435229897, green: 0.353181839, blue: 0.3607789278, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8584234118, green: 0.1023389474, blue: 0.4474884868, alpha: 1)
        gLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gLayer.locations = [0, 1]
        view.layer.addSublayer(gLayer)
        gLayer.frame = view.bounds
    }
    
    fileprivate func setupNotificationsObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
            self.view.transform = .identity
        })
    }
    
    fileprivate func setupTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDissmiss)))
    }
    
    @objc fileprivate func handleKeyboardDissmiss() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleTextChange(textField : UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid
            self.registerButton.backgroundColor = #colorLiteral(red: 0.7772458196, green: 0.09371804446, blue: 0.323792249, alpha: 1)
            self.registerButton.backgroundColor = isFormValid ? #colorLiteral(red: 0.8235294118, green: 0, blue: 0.3254901961, alpha: 1) : .lightGray
            self.registerButton.setTitleColor(isFormValid ? .white : .gray, for: .normal)
        }
        
        registrationViewModel.bindableImage.bind { [unowned self] (img) in
                    self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)

                }
        
//        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
//            self.registerButton.isEnabled = isFormValid
//            if isFormValid {
//                self.registerButton.backgroundColor = #colorLiteral(red: 0.7772458196, green: 0.09371804446, blue: 0.323792249, alpha: 1)
//                self.registerButton.setTitleColor(.white, for: .normal)
//            } else {
//                self.registerButton.backgroundColor = .lightGray
//                self.registerButton.setTitleColor(.darkGray, for: .normal)
//            }
//        }

//        registrationViewModel.imageObserver = { [unowned self] img in
//            self.selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
//
//        }
    }
    
    @objc fileprivate func handleRegister() {
        handleKeyboardDissmiss()
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
            
            print("Successfully registred User:", res?.user.uid ?? "")
        }
    }
    
    @objc func handleSelectPhoto() {
        let imagePickercontroller = UIImagePickerController()
        imagePickercontroller.delegate = self
        present(imagePickercontroller, animated: true)
    }
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gLayer.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self) // if not we'll have retain cycle!
    }
}

extension RegistrationController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        registrationViewModel.bindableImage.value = image
//        registrationViewModel.image = image
        dismiss(animated: true, completion: nil)
    }
    
}
