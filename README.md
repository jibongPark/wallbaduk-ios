# 벽바둑 (Wall Baduk) iOS 앱

전략적 사고력과 공간 지각 능력을 요구하는 벽바둑 게임을 iOS 플랫폼에서 제공하는 모바일 게임 앱입니다.

## 📱 프로젝트 개요

- **개발 언어**: Swift 5.9+
- **UI 프레임워크**: SwiftUI
- **최소 지원 버전**: iOS 16.0+
- **아키텍처**: RIBs + Clean Architecture
- **프로젝트 관리**: Tuist

## 🏗️ 프로젝트 구조

```
WallBaduk/
├── Apps/                          # 앱 타겟들
│   ├── WallBaduk/                # 메인 앱
│   ├── WallBadukDemo/            # 데모/개발용 앱
│   └── WallBadukTests/           # 통합 테스트 앱
│
├── Core/                         # 공통 모듈들
│   ├── DI/                      # 의존성 주입
│   ├── Extensions/              # Swift/SwiftUI 확장
│   ├── DesignSystem/           # 디자인 시스템
│   ├── Networking/             # 네트워킹 모듈
│   └── Utils/                  # 유틸리티
│
├── Modules/                     # 도메인 모듈들
│   ├── GameDomain/             # 게임 도메인 모듈
│   └── GameData/               # 게임 데이터 모듈
│
├── Features/                   # 기능별 RIB 모듈들
│   ├── GameBoard/              # 게임보드 RIB
│   ├── GameMenu/               # 게임메뉴 RIB
│   └── GameResult/             # 게임결과 RIB
│
├── Tuist/                      # Tuist 설정
└── Project.swift               # 루트 프로젝트 매니페스트
```

## 🚀 개발 환경 설정

### 1. Tuist 설치
```bash
curl -Ls https://install.tuist.io | bash
```

### 2. 프로젝트 의존성 설치 및 생성
```bash
# 의존성 패키지 다운로드
tuist fetch

# 프로젝트 파일 생성
tuist generate
```

### 3. Xcode에서 프로젝트 열기
```bash
open WallBaduk.xcworkspace
```

## 🎮 주요 기능

### 게임 모드
- **로컬 멀티플레이어**: 2-4명 턴 기반 게임
- **AI 대전**: 난이도별 AI 상대 (쉬움/보통/어려움)
- **튜토리얼 모드**: 게임 규칙 학습 및 연습

### 게임 설정
- **게임판 크기**: 9x9, 13x13 선택 가능
- **플레이어 수**: 2-4명 설정
- **제한 시간**: 30초/60초/90초/무제한 선택
- **색상 테마**: 전통/모던/다크 모드

## 🏗️ 아키텍처

### RIBs + Clean Architecture
- **Domain Layer**: Entity, UseCase, Repository (Interface)
- **Data Layer**: Repository Implementation, DataSource, DTO
- **Presentation Layer**: RIBs (Router, Interactor, Builder, View)

### 모듈 의존성 구조
```
App Layer
├── GameMenu RIB
├── GameBoard RIB
└── GameResult RIB
    ↓
Domain/Data Layer
├── GameDomain (Entities, UseCases, Repositories)
└── GameData (Repository Implementations, DataSources)
    ↓
Core Layer
├── DesignSystem
├── Extensions  
├── Networking
├── Utils
└── DI
```

## 🛠️ 개발 명령어

### 빌드
```bash
# 전체 프로젝트 빌드
tuist build

# 특정 모듈 빌드
tuist build GameDomain
tuist build GameBoard
```

### 테스트
```bash
# 전체 테스트 실행
tuist test

# 모듈별 테스트
tuist test GameDomainTests
tuist test GameBoardTests
```

### 프로젝트 재생성
```bash
# 클린 빌드
tuist clean && tuist generate
```

## 📋 개발 일정

### 1주차: 기본 프로젝트 설정 및 Core 모듈
- [x] Tuist 프로젝트 초기 설정
- [x] Core 모듈 구현 (DI, Extensions, DesignSystem, Utils)
- [x] Game Domain 레이어 구현
- [x] 메인 앱 기본 구조

### 2주차: Game Domain/Data 및 GameMenu RIB
- [ ] Game Data 레이어 구현
- [ ] Game UseCases 구현
- [ ] GameMenu RIB 구현
- [ ] 도메인/데이터 레이어 테스트

### 3주차: GameBoard RIB 및 핵심 게임플레이
- [ ] GameBoard RIB 구현
- [ ] 게임 인터랙션 구현
- [ ] UI/UX 개선
- [ ] RIB 플로우 완성

### 4주차: GameResult RIB, AI 시스템 및 배포 준비
- [ ] GameResult RIB 구현
- [ ] AI 시스템 구현
- [ ] 통합 테스트 및 최적화
- [ ] 배포 준비

## 🔧 기술 스택

- **언어**: Swift 5.9+
- **UI**: SwiftUI
- **아키텍처**: RIBs
- **리액티브**: RxSwift, RxCocoa
- **프로젝트 관리**: Tuist
- **테스팅**: XCTest
- **데이터 저장**: CoreData, UserDefaults

## 📱 지원 환경

- **iOS**: 16.0+
- **디바이스**: iPhone (iPad는 추후 지원 예정)
- **언어**: 한국어

## 🎯 게임 규칙

벽바둑은 전략적 위치 점유 게임으로, 플레이어들이 말을 이동하고 벽을 설치하여 최대한 많은 영역을 차지하는 것이 목표입니다.

1. **말 이동**: 턴마다 자신의 말을 인접한 빈 칸으로 이동
2. **벽 설치**: 상대방의 이동을 제한하기 위해 벽 설치
3. **점수 계산**: 게임 종료 시 각 플레이어가 점유한 영역 크기로 승부 결정

## 📄 라이센스

이 프로젝트는 개인 프로젝트입니다.

## 👥 기여하기

현재 개인 개발 프로젝트로 진행되고 있습니다.

---

**벽바둑 - 전략과 공간지각의 만남** 🎮 