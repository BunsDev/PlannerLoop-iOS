//
//
// ComponentsModel.swift
// PlannerLoop
// Data structures for view components
// Created by Tomáš Tomala
//
	

import Foundation
import SwiftUI


///Values of draggable sheet state
enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    /// Returns current change in position due to dragging
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    /// If sheet is currently moved with, returns true
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

///Enumeration of error types
enum ErrorDescription: Error, LocalizedError, Identifiable{
    case noError
    //API Errs
    case unknown
    case noConnection
    case invalidCredentials
    case invalidServerResponse
    case suspendedAccount
    case invalidUserData
    case invalidDBFile
    case noCredits
    case alreadyRegistered
    case cannotClose
    case cannotCloseFailed
    //Operation Errs
    case invalidDisponibilityTimes
    case invalidNameEmployee
    case invalidName
    //Operation Errs
    case invalidPriority
    case invalidInstallTime
    case invalidIterations
    case invalidIterDuration
    case invalidDeadline
    case noResource
    case noResourceID
    case noTBSOperations
    //Database Errs
    case notScheduled
    case openingDatabase
    case databaseInsert
    case noResourceInfo
    case invalidScheduled
    case noOperationInfo
    case invalidDownloadedFile

    var id: String {self.localizedDescription}

    ///Error description
    var errorDescription: String {
        switch self {
        case .unknown:
            return NSLocalizedString("Neznámá chyba. Prosím opakujte akci", comment: "")
        case .noError:
            return NSLocalizedString("Chyba nenalezena", comment: "")
        case .invalidDisponibilityTimes:
            return NSLocalizedString("Neplatný čas disponibility", comment: "")
        case .invalidNameEmployee:
            return NSLocalizedString("Neplatné jméno", comment: "")
        case .invalidName:
            return NSLocalizedString("Neplatný název", comment: "")
        case .invalidPriority:
            return NSLocalizedString("Neplatný údaj priority", comment: "")
        case .invalidInstallTime:
            return NSLocalizedString("Neplatná doba přípravy", comment: "")
        case .invalidIterations:
            return NSLocalizedString("Neplatný počet iterací", comment: "")
        case .invalidIterDuration:
            return NSLocalizedString("Neplatná doba iterace", comment: "")
        case .invalidDeadline:
            return NSLocalizedString("Neplatný deadline", comment: "")
        case .noResource:
            return NSLocalizedString("Není zvolen zdroj", comment: "")
        case .noResourceID:
            return NSLocalizedString("Zvolen neznámý zdroj", comment: "")
        case .noResourceInfo:
            return NSLocalizedString("Nelze získat potřebné informace o zdroji", comment: "")
        case .noOperationInfo:
            return NSLocalizedString("Nelze získat potřebné informace o operaci", comment: "")
        case .noConnection:
            return NSLocalizedString("Problém s kontaktováním služby. Prosím opakujte akci později", comment: "")
        case .invalidServerResponse:
            return NSLocalizedString("Neplatný požadavek. Prosím opakujte akci", comment: "")
        case .invalidCredentials:
            return NSLocalizedString("Neplatné přihlašovací údaje", comment: "")
        case .invalidUserData:
            return NSLocalizedString("Neplatné uživatelské údaje", comment: "")
        case .suspendedAccount:
            return NSLocalizedString("Účet pozastaven. Prosím kontaktujte podporu", comment: "")
        case .invalidDBFile:
            return NSLocalizedString("Neplatný soubor operací k rozvrhutí", comment: "")
        case .notScheduled:
            return NSLocalizedString("Neznámá chyba při rozvrhování operací", comment: "")
        case .openingDatabase:
            return NSLocalizedString("Nepodařilo se vytvořit soubor operací k rozvrnutí", comment: "")
        case .databaseInsert:
            return NSLocalizedString("Nepodařilo se vložit operaci do souboru operací", comment: "")
        case .noTBSOperations:
            return NSLocalizedString("Nenalezeny operace k rozvhnutí", comment: "")
        case .noCredits:
            return NSLocalizedString("Nedostatek kreditů", comment: "")
        case .alreadyRegistered:
            return NSLocalizedString("Účet již existuje", comment: "")
        case .invalidDownloadedFile:
            return NSLocalizedString("Nepodařilo se zpracovat rozvrhnuté operace", comment: "")
        case .invalidScheduled:
            return NSLocalizedString("Nepodařilo se zpracovat rozvrhnutou operaci", comment: "")
        case .cannotClose:
            return NSLocalizedString("Nepodařilo se uzavřít rozvrhnutou úlohu", comment: "")
        case .cannotCloseFailed:
            return NSLocalizedString("Nepodařilo se uzavřít chybnou úlohu", comment: "")
        }
    }
}
