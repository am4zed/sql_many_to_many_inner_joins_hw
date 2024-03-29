require_relative('./film')
require_relative('./customer')
require_relative('./screening')
require_relative('../db/sql_runner')

class Ticket
  attr_accessor :customer_id, :film_id, :screening_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save()
    sql = 'INSERT INTO tickets (customer_id, film_id, screening_id) VALUES ($1, $2, $3) RETURNING id'
    values = [@customer_id, @film_id, @screening_id]
    @id = SqlRunner.run(sql,values).first['id'].to_i
  end

  def self.all()
    sql = 'SELECT * FROM tickets'
    ticket_hashes = SqlRunner.run(sql)
    return map_items(ticket_hashes)
  end

  def self.map_items(ticket_hashes)
    return ticket_hashes.map { |hash| Ticket.new(hash)}
  end

  def update()
    sql = 'UPDATE tickets SET (customer_id, film_id, screening_id) = ($1, $2, $3)
          WHERE id = $4'
    values = [@customer_id, @film_id, @screening_id, @id]
    SqlRunner.run(sql,values)
  end

  def self.delete_all()
    sql = 'DELETE FROM tickets'
    SqlRunner.run(sql)
  end

  def delete()
    sql = 'DELETE FROM tickets WHERE id = $1'
    values = [@id]
    SqlRunner.run(sql,values)
  end

end
