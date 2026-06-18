import UIKit

final class CustomButton: UIButton {
    enum ButtonStyle {
        case outlineBlue
        case outlineRed
        case clear
    }
    
    private let style: ButtonStyle
    
    init(style: ButtonStyle, title: String) {
        self.style = style
        super.init(frame: .zero)
        applyStyle(style, title: title)
        automaticallyUpdatesConfiguration = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
    
    private func applyStyle(_ style: ButtonStyle, title: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var updated = incoming
            updated.font = .systemFont(ofSize: 14, weight: .medium)
            return updated
        }
        
        config.baseBackgroundColor = .clear
        clipsToBounds = true
        
        switch style {
            case .outlineBlue:
                config.image = UIImage(systemName: "plus")
                config.imagePlacement = .leading
                config.imagePadding = 8
                config.baseForegroundColor = .systemBlue
                
                layer.borderColor = UIColor.systemBlue.cgColor
                layer.borderWidth = 2
            case .outlineRed:
                config.baseForegroundColor = .systemRed
                
                layer.borderColor = UIColor.systemRed.cgColor
                layer.borderWidth = 2
            case .clear:
                config.baseForegroundColor = .systemBlue
                
                layer.borderWidth = 0
        }
        
        self.configuration = config
    }
}

