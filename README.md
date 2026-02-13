# 링크 디펜서 🎮

4가지 속성의 영웅이 링크 퍼즐을 통해 몰려오는 괴물을 막아내는 모바일 디펜스 게임입니다.

## 🌟 주요 기능

- ❄️🔥⚡🍃 **4가지 속성 시스템**: Ice, Fire, Electric, Nature
- 🎯 **링크 퍼즐**: 8방향 인접 블록 연결 (대각선 포함)
- 🔙 **백트래킹**: 직전 블록으로 되돌아가면 연결 취소
- 💾 **자동 저장**: Supabase를 통한 게임 진행도 자동 저장
- 🏆 **최고 기록**: 도달한 최고 웨이브 추적
- 📱 **모바일 최적화**: 세로형 9:16 레이아웃
- ✨ **부드러운 애니메이션**: CSS + React 애니메이션

## 🎮 게임 방법

### 기본 규칙
1. **블록 연결**: 같은 속성 블록을 3개 이상 연결하여 공격
2. **데미지**: 연결된 블록 수 × 20
3. **턴 소비**: 각 공격마다 1턴 소모, 몬스터 1칸 전진
4. **웨이브 클리어**: 모든 몬스터 처치 시 +5턴 보너스

### 조작법
- **Desktop**: 마우스 드래그
- **Mobile**: 터치 드래그

### 승리 조건
- 가능한 많은 웨이브를 클리어하세요!

### 패배 조건
- 턴이 0이 되거나
- 모든 영웅의 HP가 0이 됨

## 🚀 설치 및 실행

### 1. 파일 다운로드
이 프로젝트는 단일 HTML 파일로 구성되어 있습니다.

### 2. Supabase 설정

#### 2.1. Supabase 프로젝트에서 SQL 실행
Supabase 대시보드의 **SQL Editor**로 이동하여 `setup-database.sql` 파일의 내용을 실행하세요.

```sql
-- setup-database.sql 파일의 내용 복사 & 실행
```

#### 2.2. 익명 인증 활성화
Supabase 대시보드에서:
1. **Authentication > Providers** 로 이동
2. **Anonymous Sign-ins** 활성화

### 3. 게임 실행
```bash
# 방법 1: 직접 열기
index.html 파일을 브라우저에서 열기

# 방법 2: 로컬 서버 사용 (권장)
npx serve .
# 또는
python -m http.server 8000
```

브라우저에서 `http://localhost:8000`로 접속

## 📊 데이터베이스 스키마

### game_progress 테이블
```sql
- id: uuid (PK)
- user_id: uuid (FK → auth.users)
- wave: integer (현재 웨이브)
- turn: integer (남은 턴)
- heroes: jsonb (영웅 상태)
- monsters: jsonb (몬스터 상태)
- grid: jsonb (퍼즐 그리드)
- best_wave: integer (최고 웨이브)
- created_at: timestamp
- updated_at: timestamp
```

## 🎯 게임 메커니즘

### 요소 매칭
| 속성 | 아이콘 | 색상 | 라인 |
|------|--------|------|------|
| Ice | ❄️ | 하늘색 | 1 |
| Fire | 🔥 | 빨간색 | 2 |
| Electric | ⚡ | 노란색 | 3 |
| Nature | 🍃 | 초록색 | 4 |

### 난이도 스케일링
- **몬스터 HP**: `50 + 웨이브 × 20`
- **몬스터 수**: 3웨이브마다 증가 (최대 4마리)
- **강한 몬스터**: HP 150 이상일 때 👹 아이콘

### 전투 시스템
- 영웅 위치에서 투사체 발사
- 해당 라인의 가장 가까운 몬스터 공격
- 몬스터가 영웅에 도달하면 10 데미지

## 🛠 기술 스택

- **Frontend**: React 18 (CDN)
- **Styling**: Tailwind CSS (CDN)
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Anonymous Auth
- **Build**: Single HTML file (no build process)

## 📁 파일 구조

```
Fifth/
├── index.html              # 메인 게임 파일 (모든 코드 포함)
├── setup-database.sql      # 데이터베이스 초기 설정 SQL
└── README.md              # 프로젝트 문서
```

## 🎨 포트폴리오 특징

- ✅ **완전한 단일 파일 구조**: 간단한 배포 및 공유
- ✅ **클라우드 저장**: Supabase를 통한 데이터 영속성
- ✅ **익명 인증**: 별도 로그인 없이 자동 사용자 식별
- ✅ **반응형 디자인**: 모바일 우선 UI/UX
- ✅ **부드러운 애니메이션**: 60fps 게임 경험
- ✅ **실시간 자동 저장**: 1초마다 진행도 자동 저장

## 🔧 커스터마이징

### 게임 난이도 조정
`index.html` 파일의 상수 수정:

```javascript
const INITIAL_TURNS = 12;      // 초기 턴 수
const DAMAGE_PER_BLOCK = 20;   // 블록당 데미지
const TURN_BONUS = 5;          // 웨이브 클리어 보너스
const MAX_TURNS = 35;          // 최대 턴 수
```

### 몬스터 HP 공식 변경
```javascript
function getMonsterHp(wave) {
  return 50 + wave * 20;  // 원하는 공식으로 변경
}
```

## 📝 개발 노트

### 주요 알고리즘
- **링크 검증**: 8방향 인접성 체크 + 백트래킹
- **중력 시스템**: 블록 제거 후 위에서 아래로 낙하
- **리필 메커니즘**: 빈 공간을 랜덤 요소로 채움

### 애니메이션 시퀀스
1. 영웅 공격 애니메이션 (플래시)
2. 투사체 발사 및 이동
3. 몬스터 피격 애니메이션 (흔들림)
4. 블록 제거 애니메이션 (페이드아웃)
5. 중력 적용 + 새 블록 생성

## 🐛 알려진 이슈

- [ ] 매우 빠른 드래그 시 일부 블록이 건너뛰어질 수 있음
- [ ] 네트워크 오류 시 자동 저장 재시도 로직 없음

## 📄 라이선스

이 프로젝트는 포트폴리오 목적으로 제작되었습니다.

## 👨‍💻 개발자

포트폴리오 프로젝트 - React + Supabase 통합 예제

---

**즐거운 게임 되세요! 🎮**
