puts "🌱 seed start"
# =========================
# Rooms
# =========================
room1 = Room.find_or_create_by!(name: "さくら")
room2 = Room.find_or_create_by!(name: "しゃくなげ")

puts "🌱 seed complete"
