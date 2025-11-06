require 'sinatra'
require 'slim'
require 'sqlite3'
require 'sinatra/reloader'

get('/') do
  @cat = {
    "name" => "Claws",
    "age" => "2"
  }

  slim(:index)

end

get('/bye') do
  
  slim(:bye)
  


end

get('/home') do
  slim(:home)

end

get('/about') do
  slim(:about)

end

get('/fruits/new') do

  slim(:"fruits/new")



end


#Ta bort en frukt
post ('/fruits/:id/delete') do
  #Hämta frukten
  id = params[:id].to_i
  #koppla till db
  db = SQLite3::Database.new("db/fruits.db")
  db.execute("DELETE FROM fruits WHERE id = ?",id)
  redirect('/fruits')


end

get('/fruits/:id/edit') do
  
  #koppling till db
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @special_fruit = db.execute("SELECT * FROM fruits WHERE id = ?",id).first
  #visa formulär för att uppdatera
  slim(:"fruits/edit")
end

post('/fruits/:id/update') do
  #plocka upp id, namn och amount
  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i

  #kopping till db
  db = SQLite3::Database.new("db/fruits.db")
  db.execute("UPDATE fruits SET name=?,amount=? WHERE id=?",[name,amount,id])


  #Redirect till fruits
  redirect('/fruits')
end

post('/fruits') do
  name = params[:name]
  amount = params[:amount]

  db = SQLite3::Database.new("db/fruits.db")

  db.execute("INSERT INTO fruits (name, amount) VALUES (?, ?)", [name, amount])

  redirect '/fruits'




end

get('/fruits') do
  
  query = params[:q]

  db = SQLite3::Database.new("db/fruits.db")

  db.results_as_hash = true

  if query && !query.empty?
    @datafrukt = db.execute("SELECT * FROM fruits WHERE name LIKE ?", "%#{query}%")
    
  else
    @datafrukt = db.execute("SELECT * FROM fruits")

  end




  slim(:"fruits/index")


end

get('/fruit/:id') do
  fruitsarr = ["äpple", "banan", "kokosnöt"]
  @fruit = fruitsarr[params[:id].to_i]



  
  slim(:fruits)

end

get('/animals') do
  query = params[:q]

  db = SQLite3::Database.new("db/animals.db")

  db.results_as_hash = true

  if query && !query.empty?
    @dataanimal = db.execute("SELECT * FROM animals WHERE name LIKE ?", "%#{query}%")
  else
    @dataanimal = db.execute("SELECT * FROM animals")
  end
  
  slim(:"animals/index")
end

get('/animals/new') do

  slim(:"animals/new")



end

post('/animals') do
  name = params[:name]
  amount = params[:amount]

  db = SQLite3::Database.new("db/animals.db")

  db.execute("INSERT INTO animals (name, amount) VALUES (?, ?)", [name, amount])

  redirect '/animals'
end

post ('/animals/:id/delete') do
  id = params[:id].to_i
  db = SQLite3::Database.new("db/animals.db")
  db.execute("DELETE FROM animals WHERE id = ?",id)
  redirect('/animals')
end

get('/animals/:id/edit') do
  
  #koppling till db
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @special_animal = db.execute("SELECT * FROM animals WHERE id = ?",id).first
  #visa formulär för att uppdatera
  slim(:"animals/edit")
end

post('/animals/:id/update') do
  #plocka upp id, namn och amount
  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i

  #kopping till db
  db = SQLite3::Database.new("db/animals.db")
  db.execute("UPDATE animals SET name=?,amount=? WHERE id=?",[name,amount,id])


  #Redirect till animals
  redirect('/animals')
end

get('/test') do
  @testdata = "testdata"
  slim(:test)
  
end