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
(cm6_cm1 = Course.find_or_create_by(race: cm6_2019, title: 'CM1')).update(distance: 19.7, start: '2019-09-04 07:00 +0700', stop: '2019-09-04 14:00 +0700', gain: 1355)
(cm6_cm2 = Course.find_or_create_by(race: cm6_2019, title: 'CM2')).update(distance: 43.7, start: '2019-09-04 06:00 +0700', stop: '2019-09-04 19:00 +0700', gain: 2290)
(cm6_cm3 = Course.find_or_create_by(race: cm6_2019, title: 'CM3')).update(distance: 60.1, start: '2019-09-03 06:00 +0700', stop: '2019-09-03 22:00 +0700', gain: 3590)
(cm6_cm4 = Course.find_or_create_by(race: cm6_2019, title: 'CM4')).update(distance: 77.1, start: '2019-09-03 04:00 +0700', stop: '2019-09-04 02:00 +0700', gain: 5060)
(cm6_cm5 = Course.find_or_create_by(race: cm6_2019, title: 'CM5')).update(distance: 104.3, start: '2019-09-03 07:00 +0700', stop: '2019-09-04 13:00 +0700', gain: 6380)
(cm6_cm6 = Course.find_or_create_by(race: cm6_2019, title: 'CM6')).update(distance: 143.5, start: '2019-09-03 03:00 +0700', stop: '2019-09-04 22:00 +0700', gain: 9000)

Station.find_or_create_by(course: cm6_cm6, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm6, distance:    9.7).update(code: 'HQ(1)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 06:10 +07', ascent: 1080,descent: 60)
Station.find_or_create_by(course: cm6_cm6, distance:   18.2).update(code: 'A1'   , shortname: 'MTT', name: 'น้ำตกมณฑาธาร'     , cutoff: '2019-09-03 08:00 +07', ascent: 400,descent: 1070)
Station.find_or_create_by(course: cm6_cm6, distance:   26.7).update(code: 'HQ(2)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 10:30 +07', ascent: 1070,descent: 400)
Station.find_or_create_by(course: cm6_cm6, distance:   34.5).update(code: 'W1(1)', shortname: '', name: ''			, cutoff: nil, ascent: 460,descent:390 )
Station.find_or_create_by(course: cm6_cm6, distance:   48.8).update(code: 'A2'   , shortname: 'PNK', name: 'ผานกกก'          , cutoff: '2019-09-03 16:45 +07', ascent: 690,descent: 1040)
Station.find_or_create_by(course: cm6_cm6, distance:   57.6).update(code: 'W2'   , shortname: '', name: ''                   , cutoff: '2019-09-03 19:30 +07', ascent: 630,descent: 400)
Station.find_or_create_by(course: cm6_cm6, distance:   67.1).update(code: 'HQ(3)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 22:00 +07', ascent: 660,descent: 620)
Station.find_or_create_by(course: cm6_cm6, distance:   73.9).update(code: 'A3'   , shortname: 'HK', name: 'ห้วยแก้ว'           , cutoff: '2019-09-04 00:00 +07', ascent: 60,descent: 1000)
Station.find_or_create_by(course: cm6_cm6, distance:   80.7).update(code: 'HQ(4)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 03:00 +07', ascent: 1000,descent:60 )
Station.find_or_create_by(course: cm6_cm6, distance:   88.7).update(code: 'W1(2)', shortname: '', name: '', cutoff: nil, ascent: 460,descent: 390)
Station.find_or_create_by(course: cm6_cm6, distance:   96.0).update(code: 'A4'   , shortname: 'SPT', name: 'วัดสวนพริก'        , cutoff: '2019-09-04 07:00 +07', ascent: 15,descent: 1090)
Station.find_or_create_by(course: cm6_cm6, distance:  103.3).update(code: 'W1(3)', shortname: '', name: '', cutoff: nil, ascent: 1090, descent: 15)
Station.find_or_create_by(course: cm6_cm6, distance:  111.3).update(code: 'HQ(5)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 12:25 +07', ascent: 290,descent: 350)
Station.find_or_create_by(course: cm6_cm6, distance:  123.3).update(code: 'A5'   , shortname: 'HTT', name: 'ห้วยตึงเฒ่า'        , cutoff: '2019-09-04 15:15 +07', ascent: 80,descent: 1090)
Station.find_or_create_by(course: cm6_cm6, distance:  135.3).update(code: 'HQ(6)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 19:25 +07', ascent: 1090,descent: 80)
Station.find_or_create_by(course: cm6_cm6, distance:  145.3).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-04 22:00 +07', ascent: 60,descent: 1080)


Station.find_or_create_by(course: cm6_cm5, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm5, distance:    9.7).update(code: 'HQ(1)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 10:10 +07', ascent: 1080,descent: 60)
Station.find_or_create_by(course: cm6_cm5, distance:   17.5).update(code: 'W1'   , shortname: '', name: ''			, cutoff: nil, ascent: 460,descent:390)
Station.find_or_create_by(course: cm6_cm5, distance:   31.8).update(code: 'A2'   , shortname: 'PNK', name: 'ผานกกก'          , cutoff: '2019-09-03 15:40 +07', ascent: 690,descent: 1040)
Station.find_or_create_by(course: cm6_cm5, distance:   40.6).update(code: 'W2'   , shortname: '', name: ''                   , cutoff: '2019-09-03 18:20 +07', ascent: 630,descent: 400)
Station.find_or_create_by(course: cm6_cm5, distance:   50.1).update(code: 'HQ(2)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 20:45 +07', ascent: 660,descent: 620)
Station.find_or_create_by(course: cm6_cm5, distance:   56.9).update(code: 'A3'   , shortname: 'HK', name: 'ห้วยแก้ว'           , cutoff: '2019-09-03 22:45 +07', ascent: 60,descent: 1000)
Station.find_or_create_by(course: cm6_cm5, distance:   63.7).update(code: 'HQ(3)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 01:40 +07', ascent: 1000,descent: 60)
Station.find_or_create_by(course: cm6_cm5, distance:   71.7).update(code: 'W1(2)', shortname: '', name: ''			, cutoff: nil, ascent: 460,descent: 390)
Station.find_or_create_by(course: cm6_cm5, distance:   79.0).update(code: 'A4'   , shortname: 'SPT', name: 'วัดสวนพริก'        , cutoff: '2019-09-04 05:35 +07', ascent: 15,descent: 1090)
Station.find_or_create_by(course: cm6_cm5, distance:   86.3).update(code: 'W1(3)', shortname: '', name: ''			, cutoff: nil, ascent: 1090,descent: 15)
Station.find_or_create_by(course: cm6_cm5, distance:   94.3).update(code: 'HQ(4)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 10:45 +07', ascent: 290,descent: 350)
Station.find_or_create_by(course: cm6_cm5, distance:  104.3).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-04 13:00 +07', ascent: 60,descent: 1080)

Station.find_or_create_by(course: cm6_cm4, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm4, distance:    9.7).update(code: 'HQ(1)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 07:20 +07', ascent: 1080,descent: 60)
Station.find_or_create_by(course: cm6_cm4, distance:   18.2).update(code: 'A1'   , shortname: 'MTT', name: 'น้ำตกมณฑาธาร'     , cutoff: '2019-09-03 09:20 +07', ascent: 400,descent: 1070)
Station.find_or_create_by(course: cm6_cm4, distance:   26.7).update(code: 'HQ(2)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 11:50 +07', ascent: 1070,descent: 400)
Station.find_or_create_by(course: cm6_cm4, distance:   34.5).update(code: 'W1'   , shortname: '', name: ''			, cutoff: nil, ascent: 460,descent: 390)
Station.find_or_create_by(course: cm6_cm4, distance:   48.8).update(code: 'A2'   , shortname: 'PNK', name: 'ผานกกก'          , cutoff: '2019-09-03 18:00 +07', ascent: 690,descent: 1040)
Station.find_or_create_by(course: cm6_cm4, distance:   57.6).update(code: 'W2'   , shortname: '', name: ''                   , cutoff: '2019-09-03 20:50 +07', ascent: 630,descent: 400)
Station.find_or_create_by(course: cm6_cm4, distance:   61.1).update(code: 'HQ(3)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 23:40 +07', ascent: 660,descent: 620)
Station.find_or_create_by(course: cm6_cm4, distance:   77.1).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-04 02:00 +07', ascent: 60,descent: 1080)


Station.find_or_create_by(course: cm6_cm3, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm3, distance:    9.7).update(code: 'HQ(1)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 09:20 +07', ascent: 1080, descent: 60)
Station.find_or_create_by(course: cm6_cm3, distance:   17.5).update(code: 'W1'   , shortname: '', name: ''			, cutoff: nil, ascent: 460,descent: 390)
Station.find_or_create_by(course: cm6_cm3, distance:   31.8).update(code: 'A2'   , shortname: 'PNK', name: 'ผานกกก'          , cutoff: '2019-09-03 15:00 +07', ascent: 690,descent: 1040)
Station.find_or_create_by(course: cm6_cm3, distance:   40.6).update(code: 'W2'   , shortname: '', name: ''                   , cutoff: '2019-09-03 17:25 +07', ascent: 630,descent: 400)
Station.find_or_create_by(course: cm6_cm3, distance:   50.1).update(code: 'HQ(2)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-03 19:55 +07', ascent: 660,descent: 620)
Station.find_or_create_by(course: cm6_cm3, distance:   60.1).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-03 22:00 +07', ascent: 60,descent: 1080)

Station.find_or_create_by(course: cm6_cm2, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm2, distance:    9.7).update(code: 'HQ(1)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 09:30 +07', ascent: 1080,descent: 60)
Station.find_or_create_by(course: cm6_cm2, distance:   21.7).update(code: 'A5'   , shortname: 'HTT', name: 'ห้วยตึงเฒ่า'        , cutoff: '2019-09-04 12:20 +07', ascent: 80,descent: 1090)
Station.find_or_create_by(course: cm6_cm2, distance:   33.7).update(code: 'HQ(2)', shortname: 'SNR', name: 'ศรีเนห์รู'          , cutoff: '2019-09-04 16:30 +07', ascent: 1090,descent: 80)
Station.find_or_create_by(course: cm6_cm2, distance:   43.7).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-04 19:00 +07', ascent: 60,descent: 1080)

Station.find_or_create_by(course: cm6_cm1, distance:      0).update(code: 'START', shortname: 'CM CC', name: 'ศูนย์ประชุม'      , cutoff: nil)
Station.find_or_create_by(course: cm6_cm1, distance:    9.7).update(code: 'HQ', shortname: 'SNR', name: 'ศรีเนห์รู'             , cutoff: '2019-09-04 11:00 +07', ascent: 1080,descent: 60)
Station.find_or_create_by(course: cm6_cm1, distance:   19.7).update(code: 'FINISH', shortname: 'CM CC', name: 'ศูน์ประชุม'      , cutoff: '2019-09-04 14:00 +07', ascent: 60,descent: 1080)


