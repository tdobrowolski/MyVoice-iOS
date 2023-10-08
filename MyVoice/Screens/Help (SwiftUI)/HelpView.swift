//
//  HelpView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import SwiftUI

// TODO: Scroll to expandedType from init
// FIXME: Fix navbar color, background color is set only if you open other screen

struct HelpView: View {
    @State private var expandedType: HelpContentType?
    
    private let types = HelpContentType.allCases
    private let onDone: () -> Void
    
    var body: some View {
        content
            .navigationTitle(NSLocalizedString("Help", comment: "Help"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { doneButton }
            }
            .background(
                UIColor.background?.asColor.ignoresSafeArea()
            )
    }
    
    private var content: some View {
        ScrollViewReader { proxy in
            ScrollView {
                getList(proxy)
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 16.0)
            }
        }
    }
    
    private func getList(_ scrollViewProxy: ScrollViewProxy) -> some View {
        VStack(spacing: 16.0) {
            ForEach(types) { type in
                CollapsableHelpComponentView(
                    contentType: type,
                    onTap: { id in
                        withAnimation(.easeOut) {
                            scrollViewProxy.scrollTo(id, anchor: .top)
                        }
                    },
                    isExpanded: .init(
                        get: {
                            expandedType == type
                        }, set: { isExpanded in
                            if isExpanded {
                                expandedType = type
                            } else {
                                expandedType = nil
                            }
                        }
                    )
                )
                .id(type.id)
                .animation(.bouncy(extraBounce: -0.1), value: expandedType)
            }
        }
    }
    
    private var doneButton: some View {
        Button(
            NSLocalizedString("Done", comment: "Done")
        ) {
           onDone()
        }
        .font(Fonts.Poppins.semibold(17.0).swiftUIFont)
        .foregroundColor(UIColor.orangeMain?.asColor ?? .orange)
    }
    
    init(
        contentTypeToExpand: HelpContentType? = nil,
        onDone: @escaping () -> Void
    ) {
        self.expandedType = contentTypeToExpand
        self.onDone = onDone
    }
}
