//
//  AuthService.swift
//  PetsBookApp


import FirebaseAuth

struct FireBaseUser {
    let user: User
}

final class AuthService {
    
    let userService = UserService()
    static let shared = AuthService()
    
    var currentUserHandler: ((User) -> Void)?
    
    
//MARK: - валидация логина и пароля
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minLenght = 6
        return password.count >= minLenght
    }
    
//MARK: - создаем нового пользователя
    
    func signUpUser(email: String, password: String, completion: @escaping (Result<FireBaseUser, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
            if let authResult = result {
                completion(.success(FireBaseUser(user: authResult.user)))
            }
        }
    }
    //MARK: - вход пользователя
    
    func loginUser (email: String, password: String, completion: @escaping (Result<FireBaseUser, Error>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { [self] result, error in
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
            }
            
            if let authResult = result {
                userService.getUserUID = {
                    return authResult.user.uid
                }
                completion(.success(FireBaseUser(user: authResult.user)))
            }
        }
    }
    
    //MARK: - выход пользователя
    
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
        
    }
    
    //MARK: - получить пользователя
    
    func getUser() {
        if let user = Auth.auth().currentUser {
            if let user = Auth.auth().currentUser {
                currentUserHandler?(user)
            }
        }
    }
    
    
}
