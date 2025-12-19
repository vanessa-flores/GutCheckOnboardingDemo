import Foundation

struct GettingStartedCopy {
    
    // MARK: - Goals/Motivations
    
    struct GoalsAndMotivations {
        static let headline = "What brings you to GutCheck?"
        static let helperText = "You can select multiple reasons"
        static let buttonTitle = "Continue"
        
        static var options: [Option] {
            Option.allCases.sorted(by: { $0.displayOrder < $1.displayOrder })
        }
        
        enum Option: String, CaseIterable, Identifiable {
            case understandWhatsHappening
            case curiousGutHormoneConnection
            case discoverWhatHelps
            case wantMeaningfulData
            case symptomsRelatedToPerimenopause
            case readyToExperiment
            
            var id: String { rawValue }
            
            var displayOrder: Int {
                switch self {
                case .understandWhatsHappening: return 0
                case .curiousGutHormoneConnection: return 1
                case .discoverWhatHelps: return 2
                case .wantMeaningfulData: return 3
                case .symptomsRelatedToPerimenopause: return 4
                case .readyToExperiment: return 5
                }
            }
            
            var description: String {
                switch self {
                case .understandWhatsHappening:
                    return "I want to understand what's happening in my body"
                case .curiousGutHormoneConnection:
                    return "I'm curious about the gut-hormone connection"
                case .discoverWhatHelps:
                    return "I'm ready to discover what helps me feel better"
                case .wantMeaningfulData:
                    return "I want meaningful data for conversations with my doctor"
                case .symptomsRelatedToPerimenopause:
                    return "I'm curious if my symptoms are related to perimenopause"
                case .readyToExperiment:
                    return "I'm ready to experiment and learn what works for my body"
                }
            }
        }
    }
    
    // MARK: - Gut Health Awareness
    
    struct GutHealthAwareness {
        static let headline: String = "How familiar are you with the gut-hormone connection?"
        static let buttonTitle = "Continue"
        
        static var options: [Option] {
            Option.allCases.sorted(by: { $0.displayOrder < $1.displayOrder })
        }
        
        enum Option: String, CaseIterable, Identifiable {
            case workingOnIt
            case awareAndCurious
            case interestedToLearn
            
            var id: String { rawValue }
            
            var displayOrder: Int {
                switch self {
                case .workingOnIt: return 0
                case .awareAndCurious: return 1
                case .interestedToLearn: return 2
                }
            }
            
            var description: String {
                switch self {
                case .workingOnIt: return "Yes, I'm already working on it"
                case .awareAndCurious: return "I've heard about it and I'm curious"
                case .interestedToLearn: return "No, but I'm interested to learn"
                }
            }
        }
    }
    
    // MARK: - Current Cycle Status
    
    struct CurrentCycleStatus {
        static let headline: String = "How would you describe your menstrual cycle patterns?"
        static let buttonTitle = "Continue"
        
        static var options: [Option] {
            Option.allCases.sorted(by: { $0.displayOrder < $1.displayOrder })
        }
        
        enum Option: String, CaseIterable, Identifiable {
            case regularCycles
            case irregularCycles
            case mostlyAbsent
            case postMenopausal
            
            var id: String { rawValue }
            
            var displayOrder: Int {
                switch self {
                case .regularCycles: return 0
                case .irregularCycles: return 1
                case .mostlyAbsent: return 2
                case .postMenopausal: return 3
                }
            }
            
            var description: String {
                switch self {
                case .regularCycles: return "Regular cycles (predictable timing and flow)"
                case .irregularCycles: return "Irregular cycles (unpredictable timing or flow)"
                case .mostlyAbsent: return "Very irregular or mostly absent"
                case .postMenopausal: return "Post-menopausal (12+ months without a period)"
                }
            }
        }
    }
    
    // MARK: - Symptom Selection
    
    struct SymptomSelection {
        static let headline: String = "Let’s build your personal symptom tracker"
        static let helperText: String  = "Select the symptoms you experience most often. You can log these quickly anytime, and track other symptoms later."
        static let buttonTitle = "Done"
        
        static var featuredCategories: [(category: SymptomCategory, symptoms: [Symptom])] {
            let symptomsByCategory = InMemorySymptomRepository.shared.symptomsGroupedByCategory()
            let featured = symptomsByCategory.filter { $0.category.isFeatured }
            return featured.sorted(by: { $0.category.displayOrder < $1.category.displayOrder})
        }
        
        static var otherCategories: [(category: SymptomCategory, symptoms: [Symptom])] {
            let symptomsByCategory = InMemorySymptomRepository.shared.symptomsGroupedByCategory()
            let other = symptomsByCategory.filter { !$0.category.isFeatured }
            return other.sorted(by: { $0.category.displayOrder < $1.category.displayOrder})
        }
    }
}
