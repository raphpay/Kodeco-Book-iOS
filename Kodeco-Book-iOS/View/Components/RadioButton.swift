//
//  RadioButton.swift
//  Kodeco-Book-iOS
//
//  Created by Raphaël Payet on 24/01/2024.
//

import SwiftUI

struct RadioButton: View {
    var user: User
    @Binding var selectedUser: User?
    
    var body: some View {
        Button {
            selectedUser = user
        } label: {
            HStack {
                let isSelected = selectedUser?.id == user.id
                Text(user.name)
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle" : "circle")
            }
        }

    }
}
