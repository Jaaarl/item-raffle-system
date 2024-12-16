# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
MemberLevel.create!(
  level: 1,
  required_members: 0,
  coins: 0,
  )
User.create!(
  email: 'admin@gmail.com',
  password: '123456',
  password_confirmation: '123456',
  role: 'admin',
  member_level: MemberLevel.first
)
User.create!(
  email: 'client@gmail.com',
  password: '123456',
  password_confirmation: '123456',
  member_level: MemberLevel.first
)

