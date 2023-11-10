//
//  HelpView.swift
//  MyVoice
//
//  Created by Tobiasz Dobrowolski on 08/10/2023.
//

import SwiftUI

struct HelpView: View {
    @ObservedObject private var viewModel: HelpViewModel

    @State private var expandedType: HelpContentType?
    
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
            ForEach(viewModel.types) { type in
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
        .onAppear {
            guard let expandedType else { return }

            scrollViewProxy.scrollTo(expandedType.id, anchor: .top)
        }
    }
    
    private var doneButton: some View {
        Button(
            NSLocalizedString("Done", comment: "Done")
        ) {
            viewModel.didTapDone()
        }
        .font(Fonts.Poppins.semibold(17.0).swiftUIFont)
        .foregroundColor(UIColor.orangeMain?.asColor ?? .orange)
    }
    
    init(
        viewModel: HelpViewModel,
        contentTypeToExpand: HelpContentType? = nil
    ) {
        self.expandedType = contentTypeToExpand
        self.viewModel = viewModel
    }
}
