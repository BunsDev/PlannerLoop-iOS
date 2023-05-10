//
//  Authentification.swift
//  PlannerLoop
//
//  Created by Tomáš Tomala on 14/10/2021.
//

import SwiftUI

struct Authentication: View {
    @State var showRegisterScreen = false
    @EnvironmentObject var auth: AuthenticationVM
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    if showRegisterScreen {
                        Register()

                    } else {
                        Login()

                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
            .overlay(
                HStack {
                    Button(action: {
                        withAnimation{showRegisterScreen.toggle()}
                    }){
                        Text(showRegisterScreen ? "Already have an" : "Dont have an")
                            .font(.system(size:16, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text("account ")
                            .font(.system(size:16, weight: .bold))
                            .foregroundColor(Color("AccentHigh"))
                            .shadow(radius: 10)
                            .padding(.horizontal, -3)
                        Text("?")
                            .font(.system(size:16, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(.horizontal, -4)
                    }
                }.padding(.bottom, getSafeArea().bottom == 0 ? 15 : 0)
                
                ,alignment: .bottom
            )
        }
        .background(Color("Background").ignoresSafeArea())
    }
}

struct Authentication_Previews: PreviewProvider {
    @StateObject static var auth = AuthenticationVM()
    static var previews: some View {
        Authentication()
            .environmentObject(auth)

    }
}

extension View{
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea() ->UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct TitleLabel: View {
    let title : String
    var body: some View {
        Text(title)
            .font(.system(size:22, weight: .semibold))
            .fontWeight(.bold)
            .foregroundColor(Color("TypographyMedium"))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}




