//
//  ContentView.swift
//  ios1024
//
//  Created by Stephen Robinson for CIS357
//

import SwiftUI

struct GameView: View {
    @State var swipeDirection: SwipeDirection? = .none
    @StateObject var viewModel: GameViewModel = GameViewModel()
    @State private var isGameOver = false
    @State private var isGameWon = false
    @State private var gridSize = 4
    @State private var targetValue = 1024

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Title
                    Text("Welcome to 1024 by Stephen Robinson!")
                        .font(.title2)
                        .padding(.top)

                    // Grid
                    NumberGrid(viewModel: viewModel)
                        .gesture(DragGesture().onEnded {
                            swipeDirection = determineSwipeDirection($0)
                            viewModel.handleSwipe(swipeDirection!)
                        })
                        .padding()
                        .frame(maxWidth: .infinity)

                    // Reset button always visible
                    Button(action: resetGame) {
                        Text("Restart Game")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()

                    // Swipe Direction
                    if let swipeDirection {
                        Text("You swiped \(swipeDirection)")
                            .padding()
                    }

                    Text("Valid Swipes: \(viewModel.validSwipes)")
                        .font(.headline)
                        .padding()

                    // Add Settings Button for Navigation to Configuration Screen
                   NavigationLink(destination: GameConfigurationView(gridSize: $gridSize, targetValue: $targetValue)
                                   .onDisappear {
                                       viewModel.gridSize = gridSize
                                       viewModel.targetValue = targetValue
                                       viewModel.resetGame()
                                   }) {
                       Text("Settings")
                           .font(.headline)
                           .foregroundColor(.blue)
                           .padding()
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)

                // Overlay for "You Win"
                if viewModel.gameWon {
                    VStack {
                        OverlayView(message: "You Win!")
                            .font(.title)
                            .foregroundColor(.green)
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10) // Rounded corners

                        Button(action: resetGame) {
                            Text("Restart Game")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8)) // Semi-transparent background
                    .cornerRadius(20) // Optional corner radius
                    .padding(.horizontal, 20)
                }

                // Overlay for "Game Over"
                if viewModel.gameOver {
                    VStack {
                        OverlayView(message: "Game Over")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding(.bottom, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10) // Rounded corners

                        Button(action: resetGame) {
                            Text("Restart Game")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.bottom, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8)) // Semi-transparent background
                    .cornerRadius(20) // Optional corner radius
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }

    private func resetGame() {
        viewModel.resetGame()
        isGameWon = false
        isGameOver = false
    }
}

struct OverlayView: View {
    var message: String
    var body: some View {
        Text(message)
            .font(.title)
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

#Preview {
    GameView()
}

// MARK: - Number Grid
struct NumberGrid: View {
    @ObservedObject var viewModel: GameViewModel
    let size: Int = 4
    var body: some View {
          VStack(spacing: 4) {
              ForEach(0..<viewModel.gridSize, id: \.self) { row in
                  HStack(spacing: 4) {
                      ForEach(0..<viewModel.gridSize, id: \.self) { column in
                          // Check if the row and column exist within the grid bounds
                          if row < viewModel.grid.count, column < viewModel.grid[row].count {
                              let cellValue = viewModel.grid[row][column]
                              Text(cellValue == 0 ? "" : "\(cellValue)")
                                  .font(.system(size: 26))
                                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                                  .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                  .background(cellValue == 0 ? Color.gray.opacity(0.2) : Color.orange)
                                  .cornerRadius(10)
                                  .foregroundColor(.white)
                          } else {
                              Text("")  // Empty cell in case of out-of-bounds
                                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                                  .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                                  .background(Color.gray.opacity(0.2))
                                  .cornerRadius(10)
                          }
                      }
                  }
              }
          }
          .padding(4)
          .background(Color.gray.opacity(0.4))
          .cornerRadius(12)
      }
  }

// MARK: - Determine Swipe Direction
func determineSwipeDirection(_ swipe: DragGesture.Value) -> SwipeDirection {
    if abs(swipe.translation.width) > abs(swipe.translation.height) {
        return swipe.translation.width < 0 ? .left : .right
    } else {
        return swipe.translation.height < 0 ? .up : .down
    }
}

#Preview {
    GameView()
}
