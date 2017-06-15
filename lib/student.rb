
require 'pry'
class Student
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  # DB[:conn]

  attr_accessor :name, :grade, :db
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.db
    DB[:conn]
  end

  def self.create_table
    sql= "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    db.execute(sql)
  end

  def self.drop_table
    sql= "DROP TABLE students"
    db.execute(sql)
  end

  def save
    sql = ("INSERT INTO students (name, grade) VALUES (?, ?)")
    sql_args = [self.name, self.grade]
    self.class.db.execute(sql, sql_args)
    last_row = self.class.db.execute("SELECT * FROM students ORDER BY id LIMIT 1")
    @id = last_row.flatten.first
  end

  def self.create(hash)
    name = hash[:name]
    grade = hash[:grade]
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

end
