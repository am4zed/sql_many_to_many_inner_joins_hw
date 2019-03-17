require_relative('./customer')
require_relative('./ticket')
require_relative('./screening')
require_relative('../db/sql_runner')

class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = 'INSERT INTO films(title, price) VALUES ($1, $2) RETURNING id'
    values = [@title, @price]
    @id = SqlRunner.run(sql,values).first['id'].to_i
  end

  def self.all()
    sql = 'SELECT * FROM films'
    film_hashes = SqlRunner.run(sql)
    return map_items(film_hashes)
  end

  def self.map_items(film_hashes)
    return film_hashes.map { |hash| Film.new(hash)}
  end

  def update()
    sql = 'UPDATE films SET (title, price) = ($1, $2)
          WHERE id = $3'
    values = [@title, @price, @id]
    SqlRunner.run(sql,values)
  end

  def self.delete_all()
    sql = 'DELETE FROM films'
    SqlRunner.run(sql)
  end

  def delete()
    sql = 'DELETE FROM films WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def customers()
    sql = 'SELECT customers.*
          FROM customers
          INNER JOIN tickets
          ON customers.id = tickets.customer_id
          WHERE film_id = $1'
    values = [@id]
    customer_hashes = SqlRunner.run(sql,values)
    return Customer.map_items(customer_hashes)
  end

  def customer_count()
    sql = 'SELECT customers.*
          FROM customers
          INNER JOIN tickets
          ON customers.id = tickets.customer_id
          WHERE film_id = $1'
    values = [@id]
    customer_hashes= SqlRunner.run(sql,values)
    return customer_hashes.count.to_i
  end

  def screenings()
    sql = 'SELECT screenings.*
          FROM screenings
          INNER JOIN tickets
          ON screenings.id = tickets.screening_id
          WHERE tickets.film_id = $1'
    values = [@id]
    screenings_hashes = SqlRunner.run(sql,values)
    return Screening.map_items(screenings_hashes)
  end

  # def most_popular_screening
  #   sql = 'SELECT tickets.*
  #         FROM tickets
  #         INNER JOIN screenings
  #         ON screenings.id = tickets.screening_id
  #         WHERE tickets.film_id = $1'
  #   values = [@id]
  #   tickets_hashes = SqlRunner.run(sql,values)
  #   return Ticket.map_items(tickets_hashes)
  # end

end
