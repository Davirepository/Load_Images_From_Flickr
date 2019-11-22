//
//  NewTableViewCell.swift
//  UrlSessionLesson
//
//  Created by Давид on 22/11/2019.
//  Copyright © 2019 Константин Богданов. All rights reserved.
//

import UIKit

final class NewTableViewCell: UITableViewCell {
    static let reusedId = "UINewTableViewCellreuseId"
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.stopAnimating()
    }
}
