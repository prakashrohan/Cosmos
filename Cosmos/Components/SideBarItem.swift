//
//  SideBarItem.swift
//  Cosmos
//
//  Created by Rohan Prakash on 16/07/25.
//


import SwiftUI

enum SideBarItem: String, CaseIterable {
    case home       = "Home"
    case explore    = "Explore"
    case notifications = "Alerts"
    case settings   = "Settings"
    case profile    = "Profile"
    
    var icon: String {
        switch self {
        case .home:         return "house.fill"
        case .explore:      return "safari.fill"
        case .notifications:return "bell.fill"
        case .settings:     return "gearshape.fill"
        case .profile:      return "person.crop.circle.fill"
        }
    }
}

struct AestheticSidebar: View {
    @State private var selected: SideBarItem = .home
    @State private var isExpanded = true
    @Namespace private var highlight
    
    var body: some View {
        VStack(spacing: 20) {
            // Toggle expand/collapse
            Button {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            } label: {
                Image(systemName: isExpanded ? "chevron.left.circle" : "chevron.right.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.white, .gray)
            }
            .padding(.top, 20)
            
            // Menu items
            ForEach(SideBarItem.allCases, id: \.self) { item in
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selected = item
                    }
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            if selected == item {
                                // glowing pill behind icon+text
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.2))
                                    .matchedGeometryEffect(id: "highlight", in: highlight)
                                    .frame(height: 44)
                                    .shadow(color: Color.blue.opacity(0.8), radius: 10, x: 0, y: 2)
                            }
                            
                            HStack(spacing: 8) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                if isExpanded {
                                    Text(item.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            .padding(.horizontal, 12)
                            .foregroundColor(selected == item ? .white : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: isExpanded ? .leading : .center)
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 20)
        .frame(width: isExpanded ? 200 : 70)
        .background(.ultraThinMaterial)      // blur + translucency
        .overlay(
            // subtle neon border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
    }
}

struct AestheticSidebar_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            AestheticSidebar()
            Color(.darkGray).opacity(0.2)  // placeholder content
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}
