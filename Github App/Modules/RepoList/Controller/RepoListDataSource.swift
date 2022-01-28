//
//  RepoListDataSource.swift
//  Github App
//
//  Created by Artem Korzh on 27.01.2022.
//

import Foundation
import UIKit

enum RepoListSection {
    case main
}

typealias RepoListDataSource = UICollectionViewDiffableDataSource<RepoListSection, RepoListItemModel>
typealias RepoListSnapshot = NSDiffableDataSourceSnapshot<RepoListSection, RepoListItemModel>
