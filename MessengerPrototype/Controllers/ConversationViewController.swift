import UIKit

class ConversationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
    }
    
    //check user according to user default, or show login screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// 이건 뭔지 모르겠어 🙋🏻‍♂️
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_In")
        
        if !isLoggedIn {
            /// vc에 현재 ViewController을 담고, UINavigationController는 무엇인지 한번 찾아보자 🙋🏻‍♂️
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)   // 뒷 배경이 보이지 않는다 - no animation effect
        }
        
    }
    
}

/* 이번 화면을 구현하면서 배운 점 ====================================================================
1. UserDefaults.standard.bool(forKey: "logged_In")
2. UINavigationController
 
 ================================================================================================ */

