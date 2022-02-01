

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginViaWebsiteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(status: true)
        TMDBClient.getRequestToken(completionHandler: self.handleRequestTokenResponse(bool:error:))
    }
    
    func handleRequestTokenResponse(bool: Bool, error: Error?) {
        if bool {
            TMDBClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completionHandler: self.handleLoginResponse(bool:error:))
        } else {
            setLoggingIn(status: false)
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleLoginResponse(bool: Bool, error: Error?) {
        if bool {
            TMDBClient.createSessionId(completionHandler: self.handleCreateSessoinIdresponse(bool:error:))
        } else {
            setLoggingIn(status: false)
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleCreateSessoinIdresponse(bool: Bool, error: Error?) {
        setLoggingIn(status: false)
        if bool {
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func loginViaWebsiteTapped() {
        setLoggingIn(status: true)
        TMDBClient.getRequestToken { bool, error in
            if bool {
                UIApplication.shared.open(TMDBClient.Endpoints.webAuth.url, options: [:], completionHandler: nil)
            } else {
                self.setLoggingIn(status: false)
                self.showLoginFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func setLoggingIn(status: Bool) {
        if status {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
        self.emailTextField.isEnabled = !status
        self.passwordTextField.isEnabled = !status
        self.loginButton.isEnabled = !status
        self.loginViaWebsiteButton.isEnabled = !status
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
