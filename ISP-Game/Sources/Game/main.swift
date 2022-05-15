import Foundation
import Rainbow
//required libraries
//Rainbow library used for outputting color



/// Our constants that will stay the same
struct Constants {
    static let letters = 5
    static let attempts = 6
    static let separator = " "
}

/// Game board, with the solutions and attempts
struct Board {
    let solution: String
    var attempts: [String] = []

    var solved: Bool {
        attempts.contains(solution)
    }
/// Two functions below are used for rendering 
/// render will be used to loop through the player's attempts to see if it matches the word and it will also be used to append their answers 
/// renderRow will be used to create the actual board and it will check if the letters in the users attempts correspond with the actual word
    func render() -> String {
        var rows = [String]()
        for rowIndex in 0..<Constants.attempts {
            let attempt = attempts.count > rowIndex ? attempts[rowIndex] : nil
            rows.append(renderRow(attempt: attempt))
        }
        return rows.joined(separator: "\n")
    }

    private func renderRow(attempt: String?) -> String {
        guard let attempt = attempt?.lowercased() else {
            return Array(repeating: "_", count: Constants.letters).joined(separator: Constants.separator)
        }
        var letters: [String] = []
        for (solutionLetter, attemptLetter) in zip(solution, attempt) {
            if solutionLetter == attemptLetter {
                letters.append(String(attemptLetter).capitalized.green)
            }
            else if solution.contains(attemptLetter) {
                letters.append(String(attemptLetter).capitalized.yellow)
            }
            else {
                letters.append(String(attemptLetter).capitalized.white)
            }
        }
        return letters.joined(separator: Constants.separator)
    }
}

struct Game {
    static func main() {
        print("Welcome to Wordle, here is a random word:")

        guard let word = words.randomElement() else {
            fatalError("Could not find a word to play")
        }

        var board = Board(solution: word)

        while true {
            print(board.render())

            // If the board is solved, we are done
            if board.solved {
                print("Congratulations, you solved the puzzle!".green)
                print("Great job!")
                exit(0)
            }

            // Users have a fixed amount of tries
            if board.attempts.count == Constants.attempts {
                print("Sorry, you ran out of attempts. The solution was '\(board.solution)'. Please try again!".red)
                exit(0)
            }

            // Get new input from user
            print("Please enter a 5 letter word:")
            guard let input = readLine(strippingNewline: true) else {
                continue
            }
            if input.count < Constants.letters {
                print("Invalid word (too short)".blue)
                continue
            }
            if input.count > Constants.letters {
                print("Invalid word (too long)".blue)
                continue
            }
            guard words.contains(input) else {
                print("Word not found in dictionary, please enter a different word".yellow)
                continue
            }
            board.attempts.append(input)
        }
    }
}

Game.main()
