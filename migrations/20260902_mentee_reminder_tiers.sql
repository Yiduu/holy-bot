BEGIN;

-- Tiered inactivity reminders for mentees who are matched with a mentor
-- but have gone quiet (see the scheduler job in bot.js).
--
-- last_reminder_tier tracks the highest inactivity tier (1 = 3 days,
-- 2 = 7 days, 3 = 14 days) the mentee has already been messaged at for
-- the CURRENT stretch of inactivity, so the daily scheduler doesn't
-- re-send the same tier's wording every single day — a mentee is only
-- re-pinged once the 2-day resend interval elapses OR they cross into a
-- new, higher tier, whichever comes first.
--
-- last_reminder_at records when that last reminder actually went out,
-- used to gate the 2-day resend interval.
--
-- Both reset to 0 / NULL as soon as the mentee is active again, so the
-- next stretch of silence restarts the ladder at tier 1 instead of
-- picking up where it left off.
ALTER TABLE mentorship_assignments
  ADD COLUMN IF NOT EXISTS last_reminder_tier INT NOT NULL DEFAULT 0,
  ADD COLUMN IF NOT EXISTS last_reminder_at TIMESTAMPTZ;

COMMIT;
