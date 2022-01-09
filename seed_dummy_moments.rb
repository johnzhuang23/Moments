# seeding the database
# So... Looks like I've dropped my dishes table by accident and need a way to quickly insert some dummy dish records back into the database for testing. Write a standalone script named seed_dummy_dishes.rb that when run will insert 20 randomly generated dishes with images into the database. How random? totally up to you.

# you can checkout https://loremipsum.io/21-of-the-best-placeholder-image-generators/ for generating place holder images and I've included an array of dish names below. may be handy. may be not. may be make your own.


# def randomDish()
# arrDishes = ["Arepas", "Barbecue Ribs", "Bruschette with Tomato", "Bunny Chow", "Caesar Salad", "California Maki", "Caprese Salad", "Cauliflower Penne", "Cheeseburger", "Chicken Fajitas", "Chicken Milanese", "Chicken Parm", "Chicken Wings", "Chilli con Carne", "Ebiten maki", "Fettuccine Alfredo", "Fish and Chips", "French Fries", "Sausages", "French Toast", "Hummus", "Katsu Curry", "Kebab", "Lasagne", "Linguine with Clams", "Massaman Curry", "Meatballs with Sauce", "Mushroom Risotto", "Pappardelle alla Bolognese", "Pasta Carbonara", "Pasta and Beans", "Pasta with Tomato and Basil", "Peking Duck", "Philadelphia Maki", "Pho", "Pierogi", "Pizza", "Poke", "Pork Belly Buns", "Pork Sausage Roll", "Poutine", "Ricotta Stuffed Ravioli", "Risotto with Seafood", "Salmon Nigiri", "Scotch Eggs", "Seafood Paella", "Som Tam", "Souvlaki", "Stinky Tofu", "Sushi", "Tacos", "Teriyaki Chicken Donburi", "Tiramisù", "Tuna Sashimi", "Vegetable Soup"]

require 'pg'
conn = PG.connect(dbname: 'dating_app')
# conn.exec(sql)

i=0
until i == 5
  # dish = arrDishes.sample
  randomPic = "https://placekitten.com/g/200/300"
  sql = "INSERT INTO moments (email, image_url) VALUES ('cc@cc.cc','#{randomPic}');"
  conn.exec(sql)
  i+=1
end

conn.close

# end

