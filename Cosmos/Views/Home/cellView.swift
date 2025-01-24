//
//  CellView.swift
//  Cosmos
//
//  Created by Rohan Prakash on 17/01/25.
//

import SwiftUI

struct CellView: View {
    var iconName: String
    var title: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .foregroundStyle(Color.white)
                .frame(width: 40, height: 40)
            
            Text(title)
                .foregroundStyle(Color.white)
                .font(isSelected ? .rhdBold(size: 16) : .rhdRegular(size: 16))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
        }
        .frame(width: 170, height: 122)
                .background{
            if isSelected{

               
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(LinearGradient(colors: [.theme.lightPurple,.theme.darkPurple], startPoint: .topLeading, endPoint: .bottomTrailing))
            }else{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.white.opacity(0.05))
            }
        }
    }
}

#Preview {
    VStack {
        CellView(iconName: "house.fill", title: "Home", isSelected: true)
        CellView(iconName: "house.fill", title: "Home", isSelected: true)
        
    }
    .padding()
    .background(Color.black.ignoresSafeArea())
}
