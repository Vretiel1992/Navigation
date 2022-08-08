//
//  Settable.swift
//  Navigation
//
//  Created by Антон Денисюк on 11.04.2022.
//

import UIKit

protocol ViewModelProtocol {}

protocol Settable {

    func setup(with viewModel: ViewModelProtocol)
}
