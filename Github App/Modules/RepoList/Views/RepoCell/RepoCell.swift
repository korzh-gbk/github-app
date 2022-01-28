//
//  RepoCell.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import UIKit
import Kingfisher

class RepoCell: UICollectionViewCell {

    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var languageView: UIStackView!
    @IBOutlet weak var ownerView: UIStackView!

    public var repo: RepoListItemModel! {
        didSet { fillCell() }
    }
    public var onOwnerSelected: (RepoOwnerModel) -> Void = { _ in }
    private let defaultAvatar = R.image.octocat()!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTouches()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearAvatar()
    }

    // MARK: - Configuration

    private func setupTouches() {
        ownerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOwnerTap)))
    }

    // MARK: - Private methods

    private func fillCell() {
        repoNameLabel.text = repo.name
        repoDescriptionLabel.text = repo.repoDescription
        ownerNameLabel.text = repo.owner.login
        languageView.isHidden = repo.language == nil
        languageLabel.text = repo.language
        watchersLabel.text = "Watchers: \(repo.watchersCount)"
        forksLabel.text = "Forks: \(repo.forksCount)"
        issuesLabel.text = "Issues: \(repo.openIssuesCount)"
        starsLabel.text = "\(repo.starsCount)"
        ownerAvatarImageView.kf.setImage(
            with: repo.owner.avatarURL,
            placeholder: defaultAvatar
        )
    }

    private func clearAvatar() {
        ownerAvatarImageView.kf.cancelDownloadTask()
        ownerAvatarImageView.image = defaultAvatar
    }

    @objc private func handleOwnerTap() {
        guard let repo = repo else {
            return
        }
        onOwnerSelected(repo.owner)
    }
}
