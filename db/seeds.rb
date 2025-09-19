# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Erstelle Standard-Chaträume
Room.find_or_create_by(name: 'Allgemein') do |room|
  room.description = 'Hier können alle Benutzer allgemeine Diskussionen führen.'
end

Room.find_or_create_by(name: 'Entwicklung') do |room|
  room.description = 'Diskussionen über Software-Entwicklung und Programmierung.'
end

Room.find_or_create_by(name: 'Smalltalk') do |room|
  room.description = 'Für alle anderen Themen und lockere Gespräche.'
end

puts "Seed-Daten wurden erfolgreich erstellt!"
puts "Erstellt: #{Room.count} Chaträume"
