//
//  Vocab+CoreDataProperties.swift
//  VocabLearning
//
//  Created by Mikel  Frausto on 4/14/23.
//

//
//Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu
//
//Submission date: 4/22
//
//Project Name: VocabLearning
 


import Foundation
import CoreData


extension Vocab {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vocab> {
        return NSFetchRequest<Vocab>(entityName: "Vocab")
    }

    @NSManaged public var definition: String?
    @NSManaged public var translation: String?
    @NSManaged public var vocabulary: String?
    @NSManaged public var audioFilePath: String?
    @NSManaged public var vocabularyGroup: VocabularyGroup?
    
}

extension Vocab : Identifiable {

}
