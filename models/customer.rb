require_relative('./film')
require_relative('./ticket')
require_relative('../db/sql_runner')

class Customer
  attr_accessor :name, :funds
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = 'INSERT INTO customers(name, funds) VALUES ($1, $2) RETURNING id'
    values = [@name, @funds]
    @id = SqlRunner.run(sql,values).first['id'].to_i
  end

  def self.all()
    sql = 'SELECT * FROM customers'
    customer_hashes = SqlRunner.run(sql)
    return map_items(customer_hashes)
  end

  def self.map_items(customer_hashes)
    return customer_hashes.map { |hash| Customer.new(hash)}
  end

  def update()
    sql = 'UPDATE customers SET (name, funds) = ($1, $2)
          WHERE id = $3'
    values = [@name, @funds, @id]
    SqlRunner.run(sql,values)
  end

  def self.delete_all()
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

  def delete()
    sql = 'DELETE FROM customers WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql,values)
  end

  def films()
    sql = 'SELECT films.*
          FROM films
          INNER JOIN tickets
          ON films.id = tickets.film_id
          WHERE customer_id = $1'
    values = [@id]
    film_hashes = SqlRunner.run(sql,values)
    return Film.map_items(film_hashes)
  end

  def buy_film_ticket(film)
    @funds -= film.price
  end

  def ticket_count()
    sql = 'SELECT tickets.*
          FROM tickets
          WHERE customer_id = $1'
    values = [@id]
    ticket_hashes= SqlRunner.run(sql,values)
    return ticket_hashes.count.to_i
  end

end
