//
//  LearningViewModel.swift
//  CodeXNebula
//
//  ViewModel managing learning state.
//

import SwiftUI

@MainActor
class LearningViewModel: ObservableObject {
    @Published var languages: [Language] = []
    @Published var chapters: [Chapter] = []
    @Published var problems: [CodingProblem] = []
    
    @Published var selectedLanguage: Language?
    @Published var selectedChapter: Chapter?
    
    @Published var isLoadingLanguages = false
    @Published var isLoadingChapters = false
    @Published var isLoadingProblems = false
    
    private let service = LearningDataService.shared
    
    func loadLanguages() async {
        isLoadingLanguages = true
        languages = await service.getLanguages()
        isLoadingLanguages = false
    }
    
    func selectLanguage(_ language: Language) async {
        selectedLanguage = language
        isLoadingChapters = true
        chapters = await service.getChapters(for: language.id)
        isLoadingChapters = false
    }
    
    func selectChapter(_ chapter: Chapter) async {
        selectedChapter = chapter
        guard let langId = selectedLanguage?.id else { return }
        isLoadingProblems = true
        var fetchedProblems = await service.getProblems(for: chapter.id, languageId: langId)
        
        if let user = UserStorageService.shared.getCurrentUserSession() {
            for i in 0..<fetchedProblems.count {
                if user.completedProblems.contains(fetchedProblems[i].id) {
                    fetchedProblems[i].isCompleted = true
                }
            }
        }
        
        problems = fetchedProblems
        isLoadingProblems = false
    }
}
