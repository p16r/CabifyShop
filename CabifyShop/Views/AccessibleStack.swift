//
//	AccessibleStack.swift
//	CabifyShop
//
//	Created by Prathamesh Kowarkar on 2023-02-06.
//

import SwiftUI

enum AccessibleAlignment {

	case horizontal(VerticalAlignment, accessibleHorizontalAlignment: HorizontalAlignment = .center)
	case vertical(HorizontalAlignment)

}

struct AccessibleStack<Content: View>: View {

	@Environment(\.dynamicTypeSize) private var dynamicTypeSize

	private let alignment: AccessibleAlignment
	private let spacing: CGFloat?
	@ViewBuilder private var stackContents: () -> Content

	init(
		alignment: AccessibleAlignment,
		spacing: CGFloat? = nil,
		@ViewBuilder stackContents: @escaping () -> Content
	) {
		self.alignment = alignment
		self.spacing = spacing
		self.stackContents = stackContents
	}

	var body: some View {
		switch alignment {
			case .horizontal(let verticalAlignment, let accessibleHorizontalAlignment):
				if dynamicTypeSize.isAccessibilitySize {
					VStack(alignment: accessibleHorizontalAlignment, spacing: spacing) {
						stackContents()
					}
				} else {
					HStack(alignment: verticalAlignment, spacing: spacing) {
						stackContents()
					}
				}
			case .vertical(let horizontalAlignment):
				VStack(alignment: horizontalAlignment, spacing: spacing) {
					stackContents()
				}
		}
	}

}
