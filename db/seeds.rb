puts "🌱 seed start"
# =========================
# Rooms
# =========================
room1 = Room.find_or_create_by!(name: "さくら")
room2 = Room.find_or_create_by!(name: "しゃくなげ")
room3 = Room.find_or_create_by!(name: "さつき")
room4 = Room.find_or_create_by!(name: "つつじ")
room5 = Room.find_or_create_by!(name: "アゼリア")
puts "🌱 seed complete"
