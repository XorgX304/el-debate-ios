import UIKit

struct AttributesDescriptor {

    let style: TextStyleDescriptor
    let alignment: NSTextAlignment
    let lineSpacing: CGFloat
    let kern: Double

    init(style: TextStyleDescriptor,
         alignment: NSTextAlignment = .left,
         lineSpacing: CGFloat = 0.0,
         kern: Double = 0.0) {
        self.style = style
        self.alignment = alignment
        self.lineSpacing = lineSpacing
        self.kern = kern
    }

    init(textStyle: TextStyle,
         alignment: NSTextAlignment = .left,
         lineSpacing: CGFloat = 0.0,
         kern: Double = 0.0) {
        self.init(style: StyleBuilder.build(for: textStyle),
                  alignment: alignment,
                  lineSpacing: lineSpacing,
                  kern: kern)
    }

}

extension AttributesDescriptor {

    func build() -> [NSAttributedStringKey: AnyObject] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing

        return [
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
            NSAttributedStringKey.kern: NSNumber(value: kern),
            NSAttributedStringKey.foregroundColor: style.uiColor,
            NSAttributedStringKey.font: style.uiFont
        ]
    }

}

extension AttributesDescriptor {

    func copy(with color: Color) -> AttributesDescriptor {
        return AttributesDescriptor(style: style.copy(with: color),
                                    alignment: alignment,
                                    lineSpacing: lineSpacing,
                                    kern: kern)
    }

}
