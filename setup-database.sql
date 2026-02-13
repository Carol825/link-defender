-- ==========================================
-- 링크 디펜서 - Database Setup
-- ==========================================

-- 1. game_progress 테이블 생성
CREATE TABLE IF NOT EXISTS game_progress (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
  wave integer NOT NULL DEFAULT 1,
  turn integer NOT NULL DEFAULT 30,
  heroes jsonb NOT NULL,
  monsters jsonb NOT NULL,
  grid jsonb NOT NULL,
  best_wave integer DEFAULT 1,
  killed_monsters integer DEFAULT 0,
  total_plays integer DEFAULT 1,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),

  -- 중복 방지: 한 유저당 하나의 진행도만
  UNIQUE(user_id)
);

-- 2. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_game_progress_user_id ON game_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_game_progress_best_wave ON game_progress(best_wave DESC);

-- 3. Row Level Security (RLS) 활성화
ALTER TABLE game_progress ENABLE ROW LEVEL SECURITY;

-- 4. RLS 정책 생성
-- 사용자는 자신의 데이터만 조회 가능
CREATE POLICY "Users can view own progress"
  ON game_progress FOR SELECT
  USING (auth.uid() = user_id);

-- 사용자는 자신의 데이터만 삽입 가능
CREATE POLICY "Users can insert own progress"
  ON game_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 사용자는 자신의 데이터만 업데이트 가능
CREATE POLICY "Users can update own progress"
  ON game_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- 사용자는 자신의 데이터만 삭제 가능
CREATE POLICY "Users can delete own progress"
  ON game_progress FOR DELETE
  USING (auth.uid() = user_id);

-- 5. 자동 updated_at 업데이트 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 6. updated_at 자동 업데이트 트리거
DROP TRIGGER IF EXISTS update_game_progress_updated_at ON game_progress;
CREATE TRIGGER update_game_progress_updated_at
  BEFORE UPDATE ON game_progress
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 7. 글로벌 리더보드 뷰 (익명 사용자도 조회 가능)
CREATE OR REPLACE VIEW leaderboard AS
SELECT
  user_id,
  best_wave,
  total_plays,
  updated_at
FROM game_progress
ORDER BY best_wave DESC, updated_at ASC
LIMIT 100;

-- 8. 리더보드 뷰에 대한 권한 설정
GRANT SELECT ON leaderboard TO anon;
GRANT SELECT ON leaderboard TO authenticated;

-- ==========================================
-- 설치 완료!
-- ==========================================
-- 이제 게임에서 익명 로그인 후 자동으로 진행도가 저장됩니다.
