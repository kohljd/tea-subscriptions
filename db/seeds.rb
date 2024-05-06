# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Customer.create(first_name: "John", last_name: "Doe", email: "email@email.com", address: "123 4th Ave, Indianapolis, IN, 46259")
Tea.create(title: "Earl Grey", description: "great in the morning", temperature: 195, brew_time: 3.5)
Tea.create(title: "Green Tea", description: "soothing", temperature: 165, brew_time: 2)