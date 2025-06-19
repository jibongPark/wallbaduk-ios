import RIBs
import RxSwift
import UIKit
import SwiftUI
import GameDomain
import DesignSystem

final class GameBoardViewController: UIViewController, GameBoardPresentable, GameBoardViewControllable {

    weak var listener: GameBoardPresentableListener?
    private let gameSettings: GameSettings
    
    init(gameSettings: GameSettings) {
        self.gameSettings = gameSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Method is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let gameContentView = GameBoardContentView(
            gameSettings: gameSettings,
            onBackTapped: { [weak self] in
                self?.listener?.didTapBackButton()
            }
        )
        
        let hostingController = UIHostingController(rootView: gameContentView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}

// MARK: - SwiftUI Content View
struct GameBoardContentView: View {
    let gameSettings: GameSettings
    let onBackTapped: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                gameInfoSection
                gameBoardSection
                Spacer()
                gameControlButtons
            }
            .navigationTitle("벽바둑")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("돌아가기") {
                        onBackTapped()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var gameInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("게임 설정")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("보드 크기: \(gameSettings.boardSize.description)")
                Text("플레이어 수: \(gameSettings.playerCount)명")
                if let aiDifficulty = gameSettings.aiDifficulty {
                    Text("AI 난이도: \(aiDifficulty.description)")
                }
                Text("시간 제한: \(gameSettings.timeLimit.description)")
                Text("테마: \(gameSettings.colorTheme.description)")
            }
            .font(.body)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private var gameBoardSection: some View {
        VStack {
            Text("게임 보드 영역")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 300)
                .overlay(
                    Text("게임 보드가 여기에 표시됩니다")
                        .font(.body)
                        .foregroundColor(.secondary)
                )
                .cornerRadius(12)
        }
        .padding(.horizontal)
    }
    
    private var gameControlButtons: some View {
        HStack(spacing: 16) {
            Button("새 게임") {
                // TODO: 새 게임 시작
            }
            .buttonStyle(.bordered)
            
            Button("일시정지") {
                // TODO: 게임 일시정지
            }
            .buttonStyle(.bordered)
            
            Button("게임 종료") {
                onBackTapped()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
} 