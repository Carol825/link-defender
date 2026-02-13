-- ==========================================
-- Add killed_monsters column to existing database
-- ==========================================

-- 기존 테이블에 killed_monsters 컬럼 추가
ALTER TABLE game_progress
ADD COLUMN IF NOT EXISTS killed_monsters integer DEFAULT 0;

-- 완료!
