/// For login
//  LoginViewController.swift
//  Messenger Prototypr
//
//  Created by Jack Lee on 2023/03/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    // 로고 삽입
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFit // 부른 로고 이미지 크기를 조정한 것
        return imageView
    }()
    
    
    // 소비자가 view 속에서 스크롤을 할 수 있도록 (with login / password textfields present) >> scroll을 할 수 있도록??? 이게 맞는 형식일까?
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    // 소비자 이메일 정보 입력창
    private let emailField: UITextField = {
        let Field = UITextField()
        Field.autocapitalizationType = .none
        Field.autocorrectionType = .no
        Field.returnKeyType = .continue    // when consumers needs to tap return, they read as 'continue'
        
        // ⬇ giving fieldType a border
        Field.layer.cornerRadius = 12  // border 테두리 깎기 정도
        Field.layer.borderWidth = 1    // border 테두리 두께
        Field.layer.borderColor = UIColor.lightGray.cgColor // UIColor을 CGColor로 변경할수도 있다!
        Field.placeholder = "이메일을 작성하세요."
        
        // ⬇ 왼쪽으로 달라붙어 있는 텍스트 창을 살짝 밀어낸 것 >> Why is it sticking to the left?
        Field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        Field.leftViewMode = .always
        Field.backgroundColor  = .white
        return Field
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true /// mask to bounds or clips to bounds
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)        /// 🙋🏻‍♂️titleLabel이 옵셔널이어야 하는 이유는 뭐지?? >> titleLabel 타입이 optional
        return button
    }()
    

    /// ⬇ 첫 화면 구현
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI() {
        /// ⬇ 구현해 놓은 텍스트 필드 입력창에 값을 받을 수 있도록 setup
        emailField.delegate = self
        passwordField.delegate = self
        
        // 1. 로그인 화면 구현
        title = "로그인하기"
        view.backgroundColor = .white
        
        // ⬇ 이건 왜 필요한건가? 🙋🏻‍♂️ >> 상단 네비게이션 바를 통해 login 창에서 새로운 계정 등록이 가능하도록
        // + 찾아보니 leftBarItem도 만들 수 있다.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "계정 만들기",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRight))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        /// ⬇ adding subViews 🔥 - 화면에 출력될 수 있도록 subView를 얹혀야 한다. ++ 🙋🏻‍♂️ 이전 구현에서는 항상 view.addSubView를 했는데 scrollView에서 구현하는 건 어떤 차이가 있는걸까? >> 찾아보니 scrollView는 UIView()에서 스크롤 기능이 더해진 view다. 쉽게 말해 - 더 긴 형식의 정보나 콘텐츠를 올릴 수 있게 된다는 뜻!
        view.addSubview(scrollView) // scrollView를 까먹었네
        scrollView.addSubview(imageView)    /// 🙋🏻‍♂️ scrollView 위에 subView를 올린다? >> ok
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    // viewDidLayout은 현재 화면에서 레이아웃 설정이 다 끝난 이후 시점을 이야기하고 있는게 맞는건가? >>
    // ⬇ 화면 상황(회전 등)에 맞춰 사이즈 구축 및 업데이트 이후 시점
    override func viewDidLayoutSubviews() {     /// viewDidLayout은 현재 화면에서 레이아웃 설정이 다 끝난 이후 시점을 이야기하고 있는게 맞는건가 > YES
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds  /// 이건 무엇을 뜻하는 건가? 🙋🏻‍♂️ >> 현재 scrollView에 있는 프레임, UIView의 위치와 크기가 전체 view의 크기와 같다고 언급하는 것, ok
        
        let size = view.width/3 /// 🙋🏻‍♂️ 이 부분이 이해가 되면서도 애매하네... 왜 3등분을 한것인가
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)

        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,   /// 🙋🏻‍♂️ 여기는 왜 width-60여야하는거지?
                                  height: 52)

        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)

        loginButton.frame = CGRect(x: 30,
                                  y: passwordField.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        
        
    }
    
    // ⬇ id,pw 작성 이후, 정보 검토 진행
    @objc private func loginButtonTapped() {
        print("\(#function)이 호출되었습니다")
        /// continue를 누르면 모든 정보가 일치한다면 키보드를 dismiss할 수 있다. or dismiss after typing every info within the textField >> 여기에 이 코드를 실행해도 문제가 없는건가? 순서대로 실행하는거면 문제 발생하지 않나? 🙋🏻‍♂️ 정보 검사해보고 resign을 해야하지 않나? >> resignFirstResponder이 뒤에 붙여지게 되면 정보를 모두 입력하더라도 내려가지를 앉는다. function이 호출은 되지만, 기능이 실행되지 않는다는 점. - ok
                    
        // ⬇ 각 textField 내 done(return) 버튼 클릭 이후, 키보드 dismiss를 위해
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else {  /// password, email이 비어있지 않는다면! && has to be atleast 6 characters long
            alertUserLoginError()
            return
        }
        
        ///firebase Login >> ⭐️ 이건 뭐지 - 추후 업데이트 및 수정
        
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "앗!", message: "다시 한번 정보를 읽어주세요", preferredStyle: .alert)
        
        /// 소비자가 받는 alert를 dismiss하기 위한 메서드도 함께 구축을 해야하는구나!
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: true)
    }
    
    
    @objc private func didTapRight() {
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
}

/// for using TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()    /// 지금 입력하는 창이 email 창이라면 이후 passwordField가 첫번째 responder이 된다
        } else if textField == passwordField {
            loginButtonTapped() // 입력하는 값이 passwordField라면, loginButton을 눌러라??? >> 🙋🏻‍♂️ 이걸 이렇게 구현해야하는 이유가 있나?
        }
        return true
    }
}


/* 이번 화면을 구현하면서 새로 배운 점들 ====================================================================

 1. UIAlertController
 2. resignFirstResponder 시점
 3. scrollView
 4. navigationController
 5. viewDidLayoutSubviews 시점
 ================================================================================================ */
