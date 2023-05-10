//
//  AuthentificationVM.swift
//  PlannerLoop
//
//

import SwiftUI

class AuthenticationVM: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressView = false
    @Published var isValidated = false
    @Published var errorInfo: ToastInfo = ToastInfo()
    
    init() {
        //Automatic login
        let loginResponse = DBUser(userID: UUID().uuidString, password: "sdads", appKey: "WSyV2Dgg5POLeUu7wm1EAtZpbYwsN1RB", email: "email@example.com", vip: 1, status: 1, tokens: 1000)
        UserDefaults.standard.setUserData(data: loginResponse)
        //End of automatic login
        checkValidation()
    }
    
    var loginDisabled: Bool {
        credentials.password.isEmpty || credentials.email.isEmpty
    }
    
    /// Change state of validation, if not validated, login form is shown
    /// - Parameter isValidated: Boolean value to change the state to
    func updateValidation(isValidated: Bool){
        withAnimation{
            self.isValidated = isValidated
        }
    }
    
    /// On app startup start to download tasks
    func startupDownloadOperations(){
        
        ApiVM.shared.downloadSchedulingOperations() { (result: Result<Int, ErrorDescription>) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let updateCounter):
                        if updateCounter > 0 {
                            ApiVM.shared.networkingErrorInfo.text = "Úspěšně rozvrženo operací: \(updateCounter)"
                            ApiVM.shared.toast = AlertToast(displayMode: .hud, type: .complete(Color("Accent")), title: "Aktualizace", subTitle: ApiVM.shared.networkingErrorInfo.text)
                            ApiVM.shared.networkingErrorInfo.show = true
                        }
                    case .failure(let err):
                        ApiVM.shared.networkingErrorInfo.text = err.errorDescription
                        ApiVM.shared.toast = AlertToast(displayMode: .hud, type: .error(Color("Danger")), title: "Chyba aktualizace", subTitle: ApiVM.shared.networkingErrorInfo.text)
                        ApiVM.shared.networkingErrorInfo.show = true
                }
            }
        }
    }
    
    /// On app startup, check for autologin
    func checkValidation(){
        //get email from UD, get user data from API and complete request
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: UserDefaults.Keys.email.rawValue) {
            updateValidation(isValidated: true)
            APIService.shared.getUserData(email: email){ [unowned self] (result: Result<DBUser, ErrorDescription>) in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let userData):
                                defaults.setUserData(data: userData)
                                startupDownloadOperations()
                        case .failure(let authError):
                            if authError == .invalidCredentials {
                                logout()
                            }
                    }
                }
            }
        }
    }
    
    /// Set validation to false and delete user info
    func logout(){
        //Delete UD info and set isValidated to false
        /* Logout disabled
        self.credentials.email = ""
        self.credentials.password = ""
        updateValidation(isValidated: false)
        UserDefaults.standard.deleteData()
        */
    }
    
    
    /// On user request login, get user data
    func login() {
        showProgressView = true
        APIService.shared.getUserData(email: credentials.email){ [unowned self] (result: Result<DBUser, ErrorDescription>) in
            //capture self via unowned self to avoid memory leak
            showProgressView = false
            DispatchQueue.main.async {
                switch result {
                    case .success(let loginResponse):
                            updateValidation(isValidated: true)
                            UserDefaults.standard.setUserData(data: loginResponse)
                            startupDownloadOperations()
                    case .failure(let authError):
                        errorInfo.text = authError.errorDescription  //capturing error
                        errorInfo.show = true
                        credentials = Credentials() //reseting credentials
                }
            }
        }
    }

}
