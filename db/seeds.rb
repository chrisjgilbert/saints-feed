# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
daily_echo = Source.create!(name: "Daily Echo")
southampton_fc = Source.create!(name: "Southampton FC")
# daily_echo.articles.create!(
#   url: "https://www.dailyecho.co.uk/news/24257044.saints-beat-cardiff-home---although-put-fight/",
#   title: "Archive photos show when Saints edged out Cardiff City in thriller at the Dell",
#   description: "Southampton will head to Cardiff this weekend hoping to keep up the pressure on the Championship top three.",
#   image_path: "https://www.dailyecho.co.uk/resources/images/17974312/"
# )
# bbc_sport = Source.create!(name: "BBC Sport")
# bbc_sport.articles.create!(
#   url: "https://www.bbc.com/sport/football/68420954",
#   title: "In-form Southampton cruise to win against Preston",
#   description: "Che Adams strikes twice as Southampton beat Preston 3-0 to narrow the gap on the Championship's top three.",
#   image_path: "https://ichef.bbci.co.uk/live-experience/cps/624/cpsprodpb/30B2/production/_133166421_shutterstock_editorial_14438403y.jpg"
# )
