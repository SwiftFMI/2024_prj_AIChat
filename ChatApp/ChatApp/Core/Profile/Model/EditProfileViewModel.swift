//
//  EditProfileViewModel.swift
//  ChatApp
//
//  Created by Kamelia Toteva on 27.01.25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

class EditProfileViewModel: ObservableObject {
    @Published var account: Account
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(fromItem: selectedImage)
            }
        }
    }
    @Published var profileImage: Image?
    @Published var username = ""
    @Published var nickname = ""
    @Published var phone_number = ""
    @Published var date_of_birth = Date.now
    
    init(account: Account) {
        self.account = account
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateAccountData() async throws {
        var data = [String : Any]()

        if !nickname.isEmpty && account.nickname != nickname {
            data["nickname"] = nickname
        }
        if !phone_number.isEmpty && account.phone_number != phone_number {
            data["phone_number"] = phone_number
        }
        if account.date_of_birth != date_of_birth {
            data["date_of_birth"] = date_of_birth
        }
        
        if !data.isEmpty {
            try await AuthenticationService.authenticator.updateAccountData(data: data)
        }
    }
}
