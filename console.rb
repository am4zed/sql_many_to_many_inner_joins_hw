require_relative('./models/film')
require_relative('./models/ticket')
require_relative('./models/customer')
require_relative('./models/screening')
require_relative('./db/sql_runner')

Screening.delete_all
Ticket.delete_all
Customer.delete_all
Film.delete_all

customer1 = Customer.new('name' => 'Marvin', 'funds' => 30)
customer1.save
customer2 = Customer.new('name' => 'Ozzy', 'funds' => 20)
customer2.save
customer3 = Customer.new('name' => 'Cindy', 'funds' => 10)
customer3.save

film1 = Film.new('title' => 'Looper', 'price' => '8')
film1.save
film2 = Film.new('title' => 'Beethoven', 'price' => '6')
film2.save

screening1 = Screening.new('film_id' => film1.id, 'time' => '15:30')
screening1.save
screening2 = Screening.new('film_id' => film1.id, 'time' => '19:30')
screening2.save
screening2 = Screening.new('film_id' => film2.id, 'time' => '19:00')
screening2.save

ticket1 = Ticket.new('customer_id' => customer2.id, 'film_id' => film2.id, 'screening_id' => 1)
ticket1.save
ticket2 = Ticket.new('customer_id' => customer2.id, 'film_id' => film1.id, 'screening_id' => 2)
ticket2.save
ticket2 = Ticket.new('customer_id' => customer3.id, 'film_id' => film1.id, 'screening_id' => 2)
ticket2.save

# p Customer.all
# p Film.all
# p Ticket.all

customer1.funds = 40
customer1.update

film2.title = 'Hook'
film2.update

# ticket2.customer_id = customer1.id
# ticket2.update

# customer1.delete
# film1.delete
# ticket2.delete

# p customer2.films

# p film1.customers
# p customer1.funds
# customer1.buy_film_ticket(film1)
# p customer1.funds
#
# p customer2.funds
# customer2.buy_film_ticket(film1)
# p customer2.funds

# p customer2.ticket_count
# p customer3.ticket_count

# p film1.customer_count
# p film2.customer_count

# p Screening.all

p film1.screenings

p film2.screenings

# p film1.most_popular_screening
