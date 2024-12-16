//
//  GameViewMode.swift
//  ios1024
//
//  Created by Stephen Robinson for CIS357
//
import SwiftUI
class GameViewModel: ObservableObject {
    @Published var grid: Array<Array<Int>>
    @Published var gameWon = false
    @Published var gameOver = false
    @Published var validSwipes = 0 // New property for valid swipes
    @Published var boardSize: Int = 4  // Default board size is 4x4

       // Function to update the board size
       func setBoardSize(size: Int) {
           boardSize = size
           resetGame()  // Optional: Reset the game when the board size changes
       }

     var gridSize: Int = 4
     var targetValue: Int = 1024
    
    /*
    init () {
        grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        placeRandomNumber()
    }*/
    init(gridSize: Int = 4, targetValue: Int = 1024) {
        self.gridSize = gridSize
        self.targetValue = targetValue
        self.grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        placeRandomNumber()
    }
    func placeRandomNumber(){ // Find all empty cells
    var emptyCells: [(Int, Int)] = []
    for row in 0..<grid.count {
        for col in 0..<grid[row].count {
            if grid[row][col] == 0 {
                emptyCells.append((row, col))
            }
        }
    }
    
    // Randomly select an empty cell
    if let randomCell = emptyCells.randomElement() {
        grid[randomCell.0][randomCell.1] = 2 // Place a '2' in that cell
    }
}
    // MARK: - Handle Swipe Actions
    func handleSwipe(_ direction: SwipeDirection) {
        let oldGrid = grid
        var isValidMove = false // Track if the swipe is valid

        switch direction {
                case .left:
                    for i in 0..<gridSize {
                        grid[i] = processLine(grid[i])
                    }
                    isValidMove = grid != oldGrid
                case .right:
                    for i in 0..<gridSize {
                        grid[i] = processLine(Array(grid[i].reversed())).reversed()
                    }
                    isValidMove = grid != oldGrid
                case .up:
                    for i in 0..<gridSize {
                        let column = getColumn(index: i)
                        let updatedColumn = processLine(column)
                        setColumn(index: i, newColumn: updatedColumn)
                    }
                    isValidMove = grid != oldGrid
                case .down:
                    for i in 0..<gridSize {
                        let column = getColumn(index: i)
                        let updatedColumn = Array(processLine(Array(column.reversed())).reversed())
                        setColumn(index: i, newColumn: updatedColumn)
                    }
                    isValidMove = grid != oldGrid
                }
                
                // If the board changed, increment valid swipes
                if isValidMove {
                    validSwipes += 1
                }
                
                if grid != oldGrid {
                    placeRandomNumber()
                }
                checkWinCondition()
                checkGameOverCondition()
            }
        
    // MARK: - Win Condition
        private func checkWinCondition() {
            for row in grid {
                if row.contains(targetValue) {
                    gameWon = true
                    return
                }
            }
        }
        
        // MARK: - Game Over Condition
        private func checkGameOverCondition() {
            if !grid.flatMap({ $0 }).contains(0) {  // No empty cells
                for i in 0..<gridSize {
                    for j in 0..<gridSize {
                        if canMerge(row: i, col: j) {
                            return  // A move is still possible
                        }
                    }
                }
                gameOver = true
            }
        }
    private func canMerge(row: Int, col: Int) -> Bool {
         let value = grid[row][col]
         // Check right
         if col + 1 < gridSize && grid[row][col + 1] == value {
             return true
         }
         // Check down
         if row + 1 < gridSize && grid[row + 1][col] == value {
             return true
         }
         return false
     }
    // MARK: - Process a Line (Row or Column)
    private func processLine(_ line: [Int]) -> [Int] {
        var newLine = line.filter { $0 != 0 } // Remove zeros
        
        // Prevent invalid range by checking the count
        if newLine.count > 1 {
            for i in 0..<(newLine.count - 1) {
                if newLine[i] == newLine[i + 1] {
                    newLine[i] *= 2
                    newLine[i + 1] = 0
                }
            }
            newLine = newLine.filter { $0 != 0 } // Remove new zeros
        }
        
        // Fill the remaining spaces with zeros
        while newLine.count < gridSize {
            newLine.append(0)
        }
        return newLine
    }

    
    // MARK: - Column Helpers
    private func getColumn(index: Int) -> [Int] {
        return grid.map { $0[index] }
    }
    
    private func setColumn(index: Int, newColumn: [Int]) {
        for i in 0..<gridSize {
            grid[i][index] = newColumn[i]
        }
    }

    // MARK: - Reset Game
    func resetGame() {
        grid = Array(repeating: Array(repeating: 0, count: gridSize), count: gridSize)
        gameWon = false
        gameOver = false
        validSwipes = 0
        placeRandomNumber()
    }

}
