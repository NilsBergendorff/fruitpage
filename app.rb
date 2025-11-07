require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'

#Ta bort frukt
post('/fruits/:id/delete')do
#Hämta sktuell frukt
id = params[:id].to_i
#Koppla till The Base
db = SQLite3::Database.new("db/fruits.db")

db.execute("DELETE FROM fruits WHERE id = ?",id)
redirect('/fruits')
end


get('/') do
  slim(:home)
end

get('/about') do
  slim(:about)
end

get('/death') do
  slim(:death)
end

get('/fruity/:id') do
  @fruits = ["äpple", "banan", "apelsin"]
  id = params[:id].to_i
  @fruits = fruits[id]
  slim(:fruits)
end



get('/fruits') do

  query = params[:q]


  #gör en kopplong till db
  db = SQLite3::Database.new("db/fruits.db")

  db.results_as_hash = true

  #hämta från db



  if query && !query.empty?
    @databased = db.execute("SELECT * FROM fruits WHERE name LIKE ?","%#{query}%")
  else
    @databased = db.execute("SELECT * FROM fruits")
  end

  p @databased


  #visa med slim
  slim(:"fruits/index")



end

get('/animals') do

  query = params[:q]


  #gör en kopplong till db
  db = SQLite3::Database.new("db/animals.db")

  db.results_as_hash = true

  #hämta från db



  if query && !query.empty?
    @databased = db.execute("SELECT * FROM animals WHERE name LIKE ?","%#{query}%")
  else
    @databased = db.execute("SELECT * FROM animals")
  end

  p @databased


  #visa med slim
  slim(:"animals/index")



end


get('/fruits/new') do
  slim(:"fruits/new")
end

get('/fruits/delete') do
  slim(:"fruits/delete")
end

post('/fruit') do

  new_fruit = params[:n]
  amount = params[:a].to_i
  db = SQLite3::Database.new("db/fruits.db")
  db.execute("INSERT INTO fruits (name, amount) VALUES (?, ?)", [new_fruit, amount])
  redirect('/fruits')
end

post('/animal') do
  new_animal = params[:n]
  amount = params[:a]
  db = SQLite3::Database.new
  db.execute("INSERT INTO animals (name, amount) VALUES (?, ?)", [new_animal, amount])

  redirect('/animals')
end

get('/fruits/:id/edit')do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @special_frukt = db.execute("SELECT * FROM fruits WHERE id = ?",id).first
  #visa formulär för att updatera
  slim(:"fruits/edit")

end

post('/fruits/:id/update')do
  #plocka upp id
  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i

  db = SQLite3::Database.new("db/fruits.db")
  db.execute("UPDATE fruits SET name=?,amount=? WHERE id=?",[name,amount,id])

  redirect('/fruits')
end