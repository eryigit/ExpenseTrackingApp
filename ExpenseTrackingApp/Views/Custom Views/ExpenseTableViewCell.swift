
import UIKit

class ExpenseTableViewCell: UITableViewCell {

static var identifier = "ExpenseCell"

    var priceLabel = TitleLabel(title: "asasdc")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        configPriceLabel()
     }
     
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    private func configPriceLabel() {
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
        ])
    }
    
}
