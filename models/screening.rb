require_relative('./film')
require_relative('./ticket')
require_relative('./customer')
require_relative('../db/sql_runner')

class Screening
  attr_accessor :time, :film_id
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @time = options['time']
  end

  def save()
    sql = 'INSERT INTO screenings (film_id, time)
          VALUES ($1, $2)
          RETURNING id'
    values =[@film_id, @time]
    @id = SqlRunner.run(sql,values).first['id'].to_i
  end

  def self.all()
    sql = 'SELECT * FROM screenings;'
    screening_hashes = SqlRunner.run(sql)
    return map_items(screening_hashes)
  end

  def self.map_items(screening_hashes)
    return screening_hashes.map { |hash| Screening.new(hash)}
  end

  def self.delete_all()
    sql = 'DELETE FROM screenings;'
    SqlRunner.run(sql)
  end

end
