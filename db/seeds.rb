puts "🌱 seed start"

# =========================
# Users
# =========================
admin = User.find_or_create_by!(name: "管理者 太郎") do |u|
  u.role = "admin"
end

user = User.find_or_create_by!(name: "一般 花子") do |u|
  u.role = "user"
end

# =========================
# Rooms
# =========================
room1 = Room.find_or_create_by!(name: "さくら")
room2 = Room.find_or_create_by!(name: "しゃくなげ")

# =========================
# Trainings
# =========================
training1 = Training.find_or_create_by!(title: "Rails基礎研修") do |t|
  t.description = "Railsの基本構造を学ぶ研修"
end

training2 = Training.find_or_create_by!(title: "Docker入門") do |t|
  t.description = "Dockerを使った開発環境構築"
end

# =========================
# Training Schedules
# =========================
schedule1 = TrainingSchedule.find_or_create_by!(
  training: training1,
  room: room1,
  date: Time.current.beginning_of_day + 3.days
)

schedule2 = TrainingSchedule.find_or_create_by!(
  training: training2,
  room: room2,
  date: Time.current.beginning_of_day + 7.days
)

# =========================
# Plans
# =========================
plan1 = Plan.find_or_create_by!(name: "新人研修プラン") do |p|
  p.description = "新入社員向け研修プラン"
end

plan2 = Plan.find_or_create_by!(name: "エンジニア強化プラン") do |p|
  p.description = "開発者向けスキルアップ"
end

# =========================
# Created Plans
# =========================
CreatedPlan.find_or_create_by!(
  plan: plan1,
  training_schedule: schedule1
)

CreatedPlan.find_or_create_by!(
  plan: plan2,
  training_schedule: schedule2
)

# =========================
# Plan Participations
# =========================
PlanParticipation.find_or_create_by!(
  plan: plan1,
  user: user
)

PlanParticipation.find_or_create_by!(
  plan: plan2,
  user: admin
)

# =========================
# Training Participations
# =========================
TrainingParticipation.find_or_create_by!(
  training_schedule: schedule1,
  user: user
) do |tp|
  tp.status = "completed"
end

TrainingParticipation.find_or_create_by!(
  training_schedule: schedule2,
  user: admin
) do |tp|
  tp.status = "scheduled"
end

# =========================
# Instructors
# =========================
Instructor.find_or_create_by!(
  training_schedule: schedule1,
  user: admin
)

Instructor.find_or_create_by!(
  training_schedule: schedule2,
  user: admin
)

puts "🌱 seed complete"
