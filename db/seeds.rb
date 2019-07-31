# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

#cm6 2019
cm6_2019 = Race.find_or_create_by(title: 'CM6 2019')
cm6_2019.courses.destroy_all
Course.find_or_create_by(race: cm6_2019, title: 'CM1', distance: 19.7, start: '2019-09-04 07:00 +0700', stop: '2019-09-04 14:00 +0700', gain: 1355)
Course.find_or_create_by(race: cm6_2019, title: 'CM2', distance: 43.7, start: '2019-09-04 06:00 +0700', stop: '2019-09-04 19:00 +0700', gain: 2290)
Course.find_or_create_by(race: cm6_2019, title: 'CM3', distance: 60.1, start: '2019-09-03 06:00 +0700', stop: '2019-09-03 22:00 +0700', gain: 3590)
Course.find_or_create_by(race: cm6_2019, title: 'CM4', distance: 77.1, start: '2019-09-03 04:00 +0700', stop: '2019-09-04 02:00 +0700', gain: 5060)
Course.find_or_create_by(race: cm6_2019, title: 'CM5', distance: 104.3, start: '2019-09-03 07:00 +0700', stop: '2019-09-04 13:00 +0700', gain: 6380)
Course.find_or_create_by(race: cm6_2019, title: 'CM6', distance: 143.5, start: '2019-09-03 03:00 +0700', stop: '2019-09-04 22:00 +0700', gain: 9000)
