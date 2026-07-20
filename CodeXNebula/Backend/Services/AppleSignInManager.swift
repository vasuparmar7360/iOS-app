//
//  AppleSignInManager.swift
//  CodeXNebula
//
//  Native Apple Sign In Manager using AuthenticationServices.
//

import Foundation
import AuthenticationServices

class AppleSignInManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    private var completion: ((Result<(email: String, fullName: String), Error>) -> Void)?
    
    func signIn(completion: @escaping (Result<(email: String, fullName: String), Error>) -> Void) {
        self.completion = completion
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let email = appleIDCredential.email ?? "appleuser_\(appleIDCredential.user.prefix(6))@privaterelay.appleid.com"
            let givenName = appleIDCredential.fullName?.givenName ?? "Apple"
            let familyName = appleIDCredential.fullName?.familyName ?? "User"
            let fullName = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
            
            completion?(.success((email: email, fullName: fullName)))
        } else {
            completion?(.failure(NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid credential type."])))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completion?(.failure(error))
    }
    
    // MARK: - ASAuthorizationControllerPresentationContextProviding
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Needs a window for presentation. This returns the first active window.
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        return window ?? UIWindow()
    }
}
