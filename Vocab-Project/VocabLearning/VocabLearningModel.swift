//
//  VocabLearningModel.swift
//  VocabLearning
//
//  Created by 庞景文 on 4/13/23.


/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */
//

import Foundation



//class VocabLearningModel {
//    init(){}
//
//    var nOfGroup = 0
//
//    var allVocabGroup: [VocabGroup] = []
//
//    func addNewVocab(vocabulary: String, translation: String, definition: String, group: String){
//        let newVocab = Vocab(vocabulary: vocabulary, translation: translation, definition: definition)
//
//        let groupName = group
//
//        for vocabGroup in allVocabGroup {
//            if groupName == vocabGroup.groupName {
//                vocabGroup.add(Vocab: newVocab)
//                return
//            }
//        }
//
//        let newVocabGroup = VocabGroup(groupName: groupName)
//        newVocabGroup.add(Vocab: newVocab)
//        allVocabGroup.append(newVocabGroup)
//        allVocabGroup = allVocabGroup.sorted{$0.groupName < $1.groupName}
//
//        nOfGroup += 1
//    }
//
//
//}
//
//
//
//
//
// class Vocab{
//     var vocabulary: String
//     var translation: String
//     var definition: String
//
//     init(vocabulary: String, translation: String, definition: String) {
//         self.vocabulary = vocabulary
//         self.translation = translation
//         self.definition = definition
//     }
// }
//
// class VocabGroup{
//     var vocabularyGroup: [Vocab] = []
//     var groupName: String
//     var nOfVocab = 0
//
//     init(groupName: String){
//         self.groupName = groupName
// }
//
// func add(Vocab: Vocab){
//     vocabularyGroup.append(Vocab)
//     nOfVocab += 1
//     vocabularyGroup = vocabularyGroup.sorted{$0.vocabulary < $1.vocabulary}
//    }
//
//     func getNOfVocab() -> Int{
//         return nOfVocab
//     }
// }
//
// 
//
