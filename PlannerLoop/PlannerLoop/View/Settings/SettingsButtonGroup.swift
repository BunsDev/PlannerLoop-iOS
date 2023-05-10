//
//
// SettingsButtonGroup.swift
// PlannerLoop
//
// Created by Tomáš Tomala
//
	

import SwiftUI

struct SettingsButtonGroup: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: horizontalSizeClass == .regular ? 2 : 1)){
                //Tokens button
                Button(action: {
                }, label: {SettingsButton(image: "creditcard", headline: "Tokeny", detail: "999")})
                //Edit account button
                NavigationLink(
                    destination: EditAccount(),
                    label: {SettingsButton(image: "person", headline: "Upravit Profil", description: "Aktualizovat Heslo")}
                )
                //Default Disponibility form
                NavigationLink(
                    destination: DefaultDisponibility(),
                    label: {SettingsButton(image: "clock", headline: "Disponibilita", description: "Nastavit výchozí disponibilitu")}
                )
                //VIP Button
                Button(action: {
                }, label: {SettingsButton(image: "star", headline: "Upgrade", description: "Obdržet VIP Status")})
                //
                Button(action: {},
                       label: {SettingsButton(image: "doc.plaintext", headline: "Podmínky použití", description: "", divider: horizontalSizeClass == .regular ? false : true)}
                )
                //Debugging mode
                Button(action: {
                },
                       label: {SettingsButton(image: "hammer", headline: "Placeholder", description: "", divider: false) }
                )
            }
        }
        .padding(5)
        .background(Color("Background"))
        .cornerRadius(10)
        .padding(5)
        .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
    }
    
}
