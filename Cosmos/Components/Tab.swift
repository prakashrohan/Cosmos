import SwiftUI

enum TabItem: String, CaseIterable {
    case home    = "ome"
    case markets = "Markets"
    case swap    = "Home"
    case wallet  = "Wallet"
    case profile = "Profile"
    
    var icon: String {
        switch self {
        case .home:    return "arrow.left.arrow.right"
        case .markets: return "clock"
        case .swap:    return "house"
        case .wallet:  return "wallet.pass"
        case .profile: return "person"
        }
    }
    
    var index: Int { Self.allCases.firstIndex(of: self)! }
}

struct AnimatedNeonTabBar: View {
    @Binding var selected: TabItem  // 🔁 bind to parent

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width - 32
            let slotWidth  = totalWidth / CGFloat(TabItem.allCases.count)

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.12))
                    .frame(height: 80)
                    .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: -4)

                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: .blue.opacity(0.8), radius: 15, x: 0, y: 5)
                    .offset(
                        x: -totalWidth/2
                            + slotWidth * CGFloat(selected.index)
                            + slotWidth/2
                    )
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: selected)

                HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.self) { item in
                        Button {
                            withAnimation {
                                selected = item
                            }
                        } label: {
                            VStack(spacing: 6) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 20, weight: .semibold))
                                Text(item.rawValue)
                                    .font(.caption2)
                            }
                            .foregroundColor(selected == item ? .white : .gray)
                            .frame(width: slotWidth, height: 80)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, geo.safeAreaInsets.bottom > 0 ? geo.safeAreaInsets.bottom : 20)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}



