//
//  DateFormatterExtension.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 13/12/23.
//

import Foundation
extension DateFormatter {
    static var formattYYYYMMDD: DateFormatter {
        let formatter = DateFormatter()
        let formato = "yyyy-MM-dd"
        formatter.dateFormat = formato
        return formatter
    }
}
