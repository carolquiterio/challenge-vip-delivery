import UIKit

class CAResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var recoverPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var email = ""
    private var loadingScreen = LoadingController()
    private var isPasswordRecovered = false
    
    private let coordinator = CAResetPasswordCoordinator()
    private let isEmailValid = CAIsEmailValidUseCase()

    internal override func viewDidLoad() {
        super.viewDidLoad()
        coordinator.controller = self
        setupView()
    }
    
    internal override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func loginButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func helpButton(_ sender: Any) {
        coordinator.navigateToCAContactUsViewController()
    }
    
    @IBAction func createAccountButton(_ sender: Any) {
        coordinator.navigateToCACreateAccountViewController()
    }
    
    @IBAction func recoverPasswordButton(_ sender: Any) {
        if(isPasswordRecovered) {
            dismiss(animated: true)
        } else {
            validateForm()
        }
    }
    
    private func validateForm() {
        let email = emailTextfield.text
        let isEmailValid = isEmailValid.simpleValidation(email)
        
        if isEmailValid {
            onValidEmailTyped()
        } else {
            onInvalidEmailTyped()
        }
    }
    
    private func onInvalidEmailTyped() {
        emailTextfield.setErrorColor()
        textLabel.textColor = .red
        textLabel.text = "Verifique o e-mail informado"
    }
    
    private func onValidEmailTyped() {
        self.view.endEditing(true)
        
        if !ConnectivityManager.shared.isConnected {
            Globals.showNoInternetCOnnection(controller: self)
        } else {
            recoverPassword()
        }
    }
    
    private func recoverPassword() {
        let userEmail = emailTextfield.text!.trimmingCharacters(in: .whitespaces)
        
        let parameters = [
            "email": userEmail
        ]
        
        BadNetworkLayer.shared.resetPassword(self, parameters: parameters) { (success) in
            if success {
                self.presentSuccessStyle()
            } else {
                self.presentErrorAlert()
            }
        }
    }
    
    private func presentSuccessStyle() {
        self.isPasswordRecovered = true
        
        self.emailTextfield.isHidden = true
        self.textLabel.isHidden = true
        self.viewSuccess.isHidden = false
        
        self.emailLabel.text = self.emailTextfield.text?.trimmingCharacters(in: .whitespaces)
        
        self.recoverPasswordButton.titleLabel?.text = "REENVIAR E-MAIL"
        self.recoverPasswordButton.setTitle("Voltar", for: .normal)
    }
    
    private func presentErrorAlert() {
        coordinator.presentGenericErrorAlert()
    }
}

// MARK: - Comportamentos de layout
extension CAResetPasswordViewController {
    
    private func setupView() {
        setupRecoverPasswordButton()
        setupLoginButton()
        setupHelpButton()
        setupCreateAccountButton()
        setupEmailField()
        
        validateEmailField()
    }
    
    private func setupRecoverPasswordButton() {
        recoverPasswordButton.layer.cornerRadius = recoverPasswordButton.bounds.height / 2
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupLoginButton() {
        loginButton.setupStyle(cornerRadiusHeight: createAccountButton.frame.height)
    }
    
    private func setupHelpButton() {
        helpButton.setupStyle(cornerRadiusHeight: createAccountButton.frame.height)
    }
    
    private func setupCreateAccountButton() {
        createAccountButton.setupStyle(cornerRadiusHeight: createAccountButton.frame.height)
    }
    
    private func setupEmailField() {
        emailTextfield.setDefaultColor()
        if !email.isEmpty {
            emailTextfield.text = email
            emailTextfield.isEnabled = false
        }
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextfield.setEditingColor()
        validateEmailField()
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextfield.setDefaultColor()
    }
}

extension CAResetPasswordViewController {
    
    private func validateEmailField() {
        if !emailTextfield.text!.isEmpty {
            enableCreateButton()
        } else {
            disableCreateButton()
        }
    }
    
    private func disableCreateButton() {
        recoverPasswordButton.backgroundColor = .gray
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = false
    }
    
    private func enableCreateButton() {
        recoverPasswordButton.backgroundColor = .blue
        recoverPasswordButton.setTitleColor(.white, for: .normal)
        recoverPasswordButton.isEnabled = true
    }
}
