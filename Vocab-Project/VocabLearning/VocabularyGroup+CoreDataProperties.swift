//
//  VocabularyGroup+CoreDataProperties.swift
//  VocabLearning
//
//  Created by Mikel  Frausto on 4/14/23.

/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */
//
//

import Foundation
import CoreData


extension VocabularyGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VocabularyGroup> {
        return NSFetchRequest<VocabularyGroup>(entityName: "VocabularyGroup")
    }

    @NSManaged public var groupName: String?
    @NSManaged public var vocab: Vocab?

}

extension VocabularyGroup : Identifiable {

}
