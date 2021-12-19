//
//  RepositoryTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Mika Urakawa on 2021/12/19.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var repoTitleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(repository: GitHubRepository) {
        repoTitleLabel.text = repository.fullName
        languageLabel.text = repository.language
    }
    
}
