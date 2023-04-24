
import UIKit

class AddViewTextFields: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .cyan
       layer.cornerRadius = 15
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40)
        ])
        self.placeholder = placeholder
        textAlignment = .center
    }
    
}
