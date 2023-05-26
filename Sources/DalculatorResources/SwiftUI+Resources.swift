//
//  SwiftUI+Resources.swift
//
//
//  Created by pbk on 2022/11/24.
//

import Foundation
import RswiftResources
#if canImport(SwiftUI)
import SwiftUI

public extension ImageResource {
    @available(iOS 13.0, tvOS 13.0, macCatalyst 13.0, watchOS 6.0, macOS 10.15, *)
    var swiftImage:SwiftUI.Image {
        .init(self)
    }
}

public extension ColorResource {
    @available(iOS 13.0, tvOS 13.0, macCatalyst 13.0, watchOS 6.0, macOS 10.15, *)
    var swiftColor:SwiftUI.Color {
        .init(self)
    }
}

public extension FontResource {
    @available(iOS 13.0, tvOS 13.0, macCatalyst 13.0, watchOS 6.0, macOS 10.15, *)
    func swiftFontOfSize(_ size:CGFloat) -> Font {
        .custom(self, size: size)
    }
}

@available(iOS 14.0, tvOS 14.0, watchOS 14.0, macCatalyst 14.0, macOS 11.0, *)
public extension Label where Title == Text, Icon == Image {
    
    init(_ title:LocalizedStringKey, image: ImageResource) {
        self.init {
            return Text(title)
        } icon: {
            return Image(image)
        }
    }
    
}
#endif
