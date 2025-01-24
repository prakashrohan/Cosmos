//
//  FontExt.swift
//  SeventhGuide
//
//  Created by Noman Zafar / nomanzafar303@gmail.com on 10/10/2024.
//

import Foundation
import SwiftUI


extension Font{

    static func rhdBold(size: CGFloat) -> Font {
        return .custom("RedHatDisplay-Bold", size: size)
    }
    
    
    static func rhdMedium(size: CGFloat) -> Font {
        return .custom("RedHatDisplay-Medium", size: size)
    }
    
    
    static func rhdRegular(size: CGFloat) -> Font {
        return .custom("RedHatDisplay-Regular", size: size)
    }
    
    
    static func rhdSemiBold(size: CGFloat) -> Font {
        return .custom("RedHatDisplay-SemiBold", size: size)
    }
    
    static func sfProSemiBold(size: CGFloat) -> Font {
        return .custom("SFPro-SemiBold", size: size)
    }
    
    
}
