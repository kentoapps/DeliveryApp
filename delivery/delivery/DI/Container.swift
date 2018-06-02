//
//  Container.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

private let assembler: Assembler = Assembler([ViewControllerAssembly(),
                                              ViewModelAssembly(),
                                              UsecaseAssembly(),
                                              TranslatorAssembly(),
                                              RepositoryAssembly(),
                                              DataStoreAssembly()])
var resolver: Resolver {
    return assembler.resolver
}
