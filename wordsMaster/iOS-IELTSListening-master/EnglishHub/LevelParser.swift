//
//  LevelParser.swift
//  ielts-listening
//
//  Created by Binh Le on 5/13/16.
//  Copyright © 2016 Binh Le. All rights reserved.
//

import UIKit

class LevelParser:NSObject, XMLParserDelegate {
    
    var lessonObject:LessonObject?
    var questionObject:QuestionObject?
    var answerObject:AnswerObject?
    
    var lessonArray = NSMutableArray()
    var lesson:String?
    var lessonId:String?
    var lessonName:String?
    var lessonPath:String?
    var sentences = NSMutableArray()
    var sentence:String?
    var questions = NSMutableArray()
    var question:String?
    var answers = NSMutableArray()
    var answer:String?
    
    func getLessonList(_ levelId:String) -> NSMutableArray {
        return self.beginParsing(levelId)
    }
    
    func beginParsing(_ selectedLevel:String) -> NSMutableArray {
        var level:String = "basic"
        if selectedLevel == "2" {
            level = "intermediate"
        }
        else if selectedLevel == "3" {
            level = "advance"
        }
        let path = Bundle.main.path(forResource: level, ofType: "xml")
        let parser = XMLParser(contentsOf: URL(fileURLWithPath: path!))!
        parser.delegate = self
        parser.parse()
        return self.lessonArray
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        lesson = elementName
        if elementName == "lessions" {
            self.lessonArray = NSMutableArray()
        }
        else if elementName == "lession" {
            self.lessonObject = LessonObject()
            self.lessonId = ""
            self.lessonName = ""
            self.lessonPath = ""
        }
        else if elementName == "sentences_list" {
            self.sentences = NSMutableArray()
        }
        else if elementName == "sentence" {
            self.sentence = ""
        }
        else if elementName == "questionaire" {
            self.questions = NSMutableArray()
        }
        else if elementName == "questions" {
            self.questionObject = QuestionObject()
            self.question = ""
        }
        else if elementName == "answers" {
            self.answers = NSMutableArray()
        }
        else if elementName == "answer" {
            self.answerObject = AnswerObject()
            self.answer = ""
            self.answerObject?.answerValue = Int(attributeDict["value"]!)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if lesson! == "id" {
            self.lessonId! += string
        }
        else if lesson! == "name" {
            self.lessonName! += string
        }
        else if lesson! == "sound" {
            self.lessonPath! += string
        }
        else if lesson! == "sentence" {
            self.sentence! += string
        }
        else if lesson! == "question" {
            self.question! += string
        }
        else if lesson! == "answer" {
            self.answer! += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "lession" {
            self.lessonObject!.lessonId = self.stringProcessing(self.lessonId!)
            self.lessonObject!.lessonName = self.stringProcessing(self.lessonName!)
            self.lessonObject!.lessonPath = self.stringProcessing(self.lessonPath!)
            self.lessonArray.add(self.lessonObject!)
        }
        else if elementName == "sentence" {
            self.sentences.add(self.stringProcessing(self.sentence!))
        }
        else if elementName == "sentences_list" {
            self.lessonObject!.conversationArray = self.sentences
        }
        else if elementName == "questions" {
            self.questionObject?.questionText = self.stringProcessing(self.question!)
            self.questions.add(self.questionObject!)
        }
        else if elementName == "answer" {
            self.answerObject?.answerText = self.stringProcessing(self.answer!)
            self.answers.add(self.answerObject!)
        }
        else if elementName == "answers" {
            self.questionObject?.answerArray = self.answers
        }
        else if elementName == "questionaire" {
            self.lessonObject?.questionArray = self.questions
        }
    }
    
    func stringProcessing(_ string:String) -> String {
        var trimmedString = string.replacingOccurrences(of: "\n", with: "")
        trimmedString = trimmedString.replacingOccurrences(of: "\t", with: "")
        trimmedString = trimmedString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
}
