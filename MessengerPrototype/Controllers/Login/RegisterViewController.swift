/// Creating new accounts
//  RegisterViewController.swift
//  Messenger Prototypr
//
//  Created by Jack Lee on 2023/03/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let emailField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "이메일 작성해주세요"
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor  = .white
        return Field
    }()
    
    private let fullNameField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "성함을 작성해주세요"
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor  = .white
        return Field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 생성하기", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let passwordField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .done
        Field.layer.cornerRadius = 12
        Field.layer.borderWidth = 1
        Field.layer.borderColor = UIColor.lightGray.cgColor
        Field.placeholder = "비밀번호를 작성하세요."
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor  = .white
        Field.isSecureTextEntry = true
        return Field
    }()
    
    
    /// 프로필 기본 이미지 삽입
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        
        //초기 화면 버튼 추가 >> 이건 왜 필요한걸까? 🙋🏻‍♂️ >> Register 창에 들어온 이상 필요없다 - ok
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
        //                                                            style: .done,
        //                                                            target: self,
        //                                                            action: #selector(didTapRight))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(fullNameField)    /// register 화면은 login과 다르다. 새로운 입력 값을 위한 창
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        ///🙋🏻‍♂️ ⬇ 아래 코드를 구현하는 이유가 뭘까? >> 입력을 할 수 있도록
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        // 소비자가 profile 이미지를 바꿀 수 있도록
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePicture))
        gesture.numberOfTouchesRequired = 1 // 이건 무엇을 의미하는거지? (for the function to work? one tap?) >> 맞다
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapChangeProfilePicture() {
        /// 위에 선언한 numberOfTouchesRequired가 호출되고 실행하는 코드 구성
        print("\(#function)이 호출되었습니다")
        presentPhotoActionSheet()
    }
    
    
    // 로그인 화면 속 로고 삽입
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        imageView.layer.cornerRadius = imageView.width/2.0
        
        fullNameField.frame = CGRect(x: 30,
                                     y: imageView.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: fullNameField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        
        registerButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom+10,
                                      width: scrollView.width-60,
                                      height: 52)
    }
    
    
    @objc private func registerButtonTapped() {
        print("\(#function)이 호출되었습니다")
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        fullNameField.resignFirstResponder()
        
        guard let fullName = fullNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !fullName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
    }
    
    func alertUserLoginError() {
        print("\(#function)이 호출되었습니다")
        
        let alert = UIAlertController(title: "앗!",
                                      message: "새로운 계정을 위해 모든 정보를 입력해주세요",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인",
                                      style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    /// register 영역에서는 필요 없는 코드
    //    @objc private func didTapRight() {
    //        print("\(#function)이 호출되었습니다")
    //
    //        let vc = RegisterViewController()
    //        vc.title = "Create Account"
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
}


/// 🙋🏻‍♂️⭐️ register 화면에서는 이 부분이 굳이 필요한가?
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
}

/// ⭐️ This allows users to get results of user taking picture or photo from camera roll
/// ++ UINavigationControllerDelegate는 UIImagePickerControllerDelegate와 함께 움직인다!
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 🙋🏻‍♂️ actionSheet만 구현하면 어플은 우리 사진첩의 권한을 가져가는건가?
    /// 그냥 안내창 역할만하는거 아니야?
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "프로필 사진",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "취소",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "사진 촬영",
                                            style: .default,
                                            /// weak self to avoid memory retention loop
                                            handler: { [weak self] _ in self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "사진 선택",
                                            style: .default,
                                            /// weak self to avoid memory retention loop
                                            handler: { [weak self] _ in self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    
    /// to keep the code modular - created 2 func below
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true /// 사진을 선택하면 편집 가능
        present(vc, animated: true) /// 화면 출력
        //        return vc
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    /// take photo or selects one
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        // print(info)
        /// ⬇ 선택된 사진의 값을 고를 수 있도록
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
                                                                                    else { return }
        self.imageView.image = selectedImage  /// 아직 selectedImage는 선택되지 않음
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
}



/* 이번 화면을 구현하면서 배운 점 ====================================================================
 1. isUserInteractionEnabled
 2. UITapGestureRecognizer
 
 3. info update
 4. presentPhotoActionSheet - action Sheet이라는게 우리가 흔히 선택하는 창을 뜻하는거였구나~
 5. UIImagePickerControllerDelegate
 ================================================================================================ */
