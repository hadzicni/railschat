# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Erstelle Admin-User
admin_user = User.find_or_create_by(email: 'admin@railschat.com') do |user|
  user.password = 'admin123'
  user.password_confirmation = 'admin123'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.admin = true
end

puts "Admin-User erstellt: #{admin_user.email} (Admin: #{admin_user.admin?})"

# Erstelle Test-User
test_user = User.find_or_create_by(email: 'test@railschat.com') do |user|
  user.password = 'test123'
  user.password_confirmation = 'test123'
  user.first_name = 'Test'
  user.last_name = 'User'
  user.admin = false
end

puts "Test-User erstellt: #{test_user.email}"

# Erstelle Standard-Chaträume
Room.find_or_create_by(name: 'Beispiel 1') do |room|
  room.description = 'Hier können alle Benutzer allgemeine Diskussionen führen.'
end

Room.find_or_create_by(name: 'Beispiel 2') do |room|
  room.description = 'Diskussionen über Software-Entwicklung und Programmierung.'
end

Room.find_or_create_by(name: 'Beispiel 3') do |room|
  room.description = 'Für alle anderen Themen und lockere Gespräche.'
end

puts "Erstellt: #{Room.count} Chaträume"
