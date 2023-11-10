//
//  CollapsableHelpComponentView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import SwiftUI

struct CollapsableHelpComponentView: View {
    private let contentType: HelpContentType
    private let onTap: (String) -> Void
    
    @Binding private var isExpanded: Bool
    
    var body: some View {
        content
            .clipped()
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            primaryHeader
                .contentShape(Rectangle())
                .onTapGesture {
                    isExpanded.toggle()
                    onTap(contentType.id)
                }
            if isExpanded {
                secondaryContent
            }
        }
        .padding(16.0)
        .background(containerBox)
    }
    
    private var primaryHeader: some View {
        HStack(spacing: 8.0) {
            Text(contentType.primaryTitle)
                .foregroundColor(UIColor.blackCustom?.asColor)
                .font(Fonts.Poppins.bold(18.0).swiftUIFont)
                .multilineTextAlignment(.leading)
            Spacer()
            chevronIcon
        }
    }
    
    private var chevronIcon: some View {
        ZStack {
            Circle()
                .fill(UIColor.blueLight?.asColor ?? .white)
                .frame(width: 40.0, height: 40.0)
            Image(systemName: "chevron.right")
                .font(.system(size: 17.0, weight: .bold))
                .foregroundColor(UIColor.blueDark?.asColor)
        }
        .rotationEffect(isExpanded ? .degrees(90.0) : .zero)
    }
    
    private var secondaryContent: some View {
//        if #available(iOS 15, *) {
//            Text(AttributedString(contentType.secondaryText))
//                .font(Fonts.Poppins.medium(14.0).swiftUIFont)
//                .multilineTextAlignment(.leading)
//                .lineSpacing(1.0)
//        } else {
            Text(contentType.secondaryText.string)
                .font(Fonts.Poppins.medium(14.0).swiftUIFont)
                .multilineTextAlignment(.leading)
                .lineSpacing(1.0)
//        }
    }
    
    private var containerBox: some View {
        RoundedRectangle(cornerRadius: 16.0)
            .fill(UIColor.whiteCustom?.asColor ?? .white)
    }
    
    init(
        contentType: HelpContentType,
        onTap: @escaping (String) -> Void,
        isExpanded: Binding<Bool>
    ) {
        self.contentType = contentType
        self.onTap = onTap
        _isExpanded = isExpanded
    }
}
