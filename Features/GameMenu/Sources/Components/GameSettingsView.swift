import SwiftUI
import GameDomain
import DesignSystem

/// 게임 설정 ViewModel
class GameSettingsViewModel: ObservableObject {
    @Published var boardSize: BoardSize = .small
    @Published var playerCount: Int = 2
    @Published var timeLimit: TimeLimit = .medium
    @Published var colorTheme: ColorTheme = .traditional
    @Published var isOnlineMode: Bool = false
    @Published var allowSpectators: Bool = false
    @Published var selectedAIDifficulty: AIDifficulty? = nil
    
    var gameSettings: GameSettings {
        return GameSettings(
            boardSize: boardSize,
            playerCount: playerCount,
            timeLimit: timeLimit,
            aiDifficulty: selectedAIDifficulty,
            colorTheme: colorTheme,
            isOnlineMode: isOnlineMode,
            allowSpectators: allowSpectators
        )
    }
    
    var isAIMode: Binding<Bool> {
        Binding(
            get: { self.selectedAIDifficulty != nil },
            set: { newValue in
                if newValue {
                    self.selectedAIDifficulty = .easy
                } else {
                    self.selectedAIDifficulty = nil
                }
            }
        )
    }
    
    func startGame() {
        // TODO: 게임 시작 로직 구현
        print("게임 시작: \(gameSettings)")
    }
}

/// 게임 설정 화면
public struct GameSettingsView: View {
    @StateObject private var viewModel = GameSettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            Form {
                // 기본 설정 섹션
                Section("기본 설정") {
                    boardSizeSection
                    playerCountSection
                    timeLimitSection
                }
                
                // AI 설정 섹션
                Section("AI 설정") {
                    aiModeToggle
                    if viewModel.selectedAIDifficulty != nil {
                        aiDifficultySection
                    }
                }
                
                // 고급 설정 섹션
                Section("고급 설정") {
                    colorThemeSection
                    onlineModeToggle
                    if viewModel.isOnlineMode {
                        allowSpectatorsToggle
                    }
                }
                
                // 게임 시작 버튼
                Section {
                    startGameButton
                }
            }
            .navigationTitle("게임 설정")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - 보드 크기 섹션
    private var boardSizeSection: some View {
        HStack {
            Text("보드 크기")
            Spacer()
            Picker("보드 크기", selection: $viewModel.boardSize) {
                ForEach(BoardSize.allCases.filter { $0 != .large }, id: \.self) { size in
                    Text(size.displayName).tag(size)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
    }
    
    // MARK: - 플레이어 수 섹션
    private var playerCountSection: some View {
        HStack {
            Text("플레이어 수")
            Spacer()
            Picker("플레이어 수", selection: $viewModel.playerCount) {
                ForEach(2...4, id: \.self) { count in
                    Text("\(count)명").tag(count)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 150)
        }
    }
    
    // MARK: - 제한 시간 섹션
    private var timeLimitSection: some View {
        HStack {
            Text("제한 시간")
            Spacer()
            Picker("제한 시간", selection: $viewModel.timeLimit) {
                ForEach(TimeLimit.allCases, id: \.self) { timeLimit in
                    Text(timeLimit.displayName).tag(timeLimit)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    // MARK: - AI 모드 토글
    private var aiModeToggle: some View {
        Toggle("AI와 게임", isOn: viewModel.isAIMode)
    }
    
    // MARK: - AI 난이도 섹션
    private var aiDifficultySection: some View {
        HStack {
            Text("AI 난이도")
            Spacer()
            Picker("AI 난이도", selection: $viewModel.selectedAIDifficulty) {
                ForEach(AIDifficulty.allCases, id: \.self) { difficulty in
                    Text(difficulty.displayName).tag(difficulty as AIDifficulty?)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
    }
    
    // MARK: - 색상 테마 섹션
    private var colorThemeSection: some View {
        HStack {
            Text("색상 테마")
            Spacer()
            Picker("색상 테마", selection: $viewModel.colorTheme) {
                ForEach(ColorTheme.allCases, id: \.self) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .pickerStyle(.menu)
        }
    }
    
    // MARK: - 온라인 모드 토글
    private var onlineModeToggle: some View {
        Toggle("온라인 게임", isOn: $viewModel.isOnlineMode)
            .disabled(true) // 현재 미구현
    }
    
    // MARK: - 관전자 허용 토글
    private var allowSpectatorsToggle: some View {
        Toggle("관전자 허용", isOn: $viewModel.allowSpectators)
    }
    
    // MARK: - 게임 시작 버튼
    private var startGameButton: some View {
        Button(action: {
            viewModel.startGame()
            dismiss()
        }) {
            HStack {
                Spacer()
                Text("게임 시작")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .background(AppColors.primary)
            .cornerRadius(10)
        }
        .disabled(!viewModel.gameSettings.isValid)
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
}

#Preview {
    GameSettingsView()
} 