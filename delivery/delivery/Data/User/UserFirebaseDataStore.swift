//
//  UserFirebaseDataStore.swift
//  delivery
//
//  Created by Sara N on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class UserFirebaseDataStore: UserDataStoreProtocol {
    let db = Firestore.firestore()
    
    func fetchUser() -> Single<UserEntity> {
        guard let user = Auth.auth().currentUser else {
            return Single.error(NomnomError.noData(message: "It's guest!"))
        }
        
        return Single<UserEntity>.create { observer -> Disposable in
            self.db.collection(USER_COLLECTION)
                .document(user.uid)
                .getDocument() { (document, error) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let user = UserEntity(dictionary: (document?.data())!) else {
                        observer(.error(NomnomError.noData(message: "Couldn't find user")))
                        return
                    }
                    observer(.success(user))
            }
            return Disposables.create()
        }
    }

    func updateAddress(address: AddressEntity) -> Completable{
        guard let user = Auth.auth().currentUser else {
            return Completable.error(NomnomError.alert(message: "SignIn is required!"))
        }
        
        return Completable.create { observer in
            self.db.collection(USER_COLLECTION)
                .document(user.uid)
                .setData(["address": address]) { err in
                    if let err = err {
                        observer(.error(NomnomError.alert(message: "Failed for some reasons!\n\(err.localizedDescription)")))
                    } else {
                        observer(.completed)
                    }
                }
            return Disposables.create()
        }
    }
    
    func updateUser(updatedUser: UserEntity) -> Completable {
        guard let currentUser = Auth.auth().currentUser else {
            return Completable.error(NomnomError.noData(message: "signIn is required"))
        }
        
        return Completable.create { observer in
                self.db.collection(USER_COLLECTION)
                    .document(currentUser.uid)
                    .setData(updatedUser.dictionary) { err in
                    if let err = err {
                        observer(.error(NomnomError.alert(message: "Failed for some reasons!\n\(err.localizedDescription)")))
                    } else {
                        observer(.completed)
                    }
                }
            return Disposables.create()
        }
    }
    
    func signUp(email: String, password: String) -> Completable {
        return Completable.create { observer -> Disposable in
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard let user = user else {
                    observer(.error(NomnomError.alert(message: "Failed to create user")))
                    return
                }
                var newUser: [String : Any] = [:]
                if let email = user.email {
                    newUser["email"] = email
                }
                
                // Save user to Firestore
                self.db.collection(USER_COLLECTION).document(user.uid).setData(newUser, completion: { error in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    observer(.completed)
                })
            })
            return Disposables.create()
        }
    }
    
    func signIn(email: String, password: String) -> Completable {
        return Completable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
                if let err = err {
                    observer(.error(NomnomError.alert(message: "Error : \(err.localizedDescription)")))
                } else {
                    observer(.completed)
                }
            })
            return Disposables.create()
        }
    }
    
    func forgotPassword(email: String) -> Completable {
        return Completable.create { observer in
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (err) in
                if let err = err {
                    observer(.error(err))
                } else {
                    observer(.completed)
                }
            })
            return Disposables.create()
        }
    }
    
    func signOut() -> Completable {
        return Completable.create(subscribe: { (observer) -> Disposable in
            do {
                try Auth.auth().signOut()
            } catch {
                observer(.error(error))
                return Disposables.create()
            }
        
            observer(.completed)
            return Disposables.create()
        })
    }
    
    func updateUser(user: UserEntity, password: String) -> Completable {
        guard let currentUser = Auth.auth().currentUser else {
                return Completable.error(NomnomError.alert(message: "SignIn is required!"))
            }
    
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)

        return Completable.create { observer in
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if let error = error {
                    observer(.error(NomnomError.alert(message: error.localizedDescription)))
                } else {
                    self.db.collection(USER_COLLECTION)
                        .document(currentUser.uid)
                        .setData(user.dictionary) { err in
                            if let err = err {
                                observer(.error(NomnomError.alert(message: err.localizedDescription)))
                            } else {
                               observer(.completed)
                            }
                    }
                }
            })
            
            return Disposables.create()
        }
    }
    
    func changePassword(currentPW: String, newPW: String) -> Completable {
        guard let currentUser = Auth.auth().currentUser else {
            return Completable.error(NomnomError.alert(message: "SignIn is required!"))
        }
        
        let credential = EmailAuthProvider.credential(withEmail: currentUser.email!, password: currentPW)
        
        return Completable.create { observer in
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
                if let error = error {
                    observer(.error(NomnomError.alert(message: error.localizedDescription)))
                } else {
                    Auth.auth().currentUser?.updatePassword(to: newPW, completion: { (error) in
                        if let error = error {
                            observer(.error(NomnomError.alert(message: error.localizedDescription)))
                        } else {
                            observer(.completed)
                        }
                    })
                }
            })
            return Disposables.create()
        }
    }
}

