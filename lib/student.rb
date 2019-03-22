require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new = self.new
    new.id = row[0]
    new.name = row[1]
    new.grade = row[2]
    new
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
    DB[:conn].execute(sql).collect do |student|
      Student.new_from_db(student)
    end
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      SQL
      data = DB[:conn].execute(sql, name)
      # binding.pry
      Student.new_from_db(data[0])

    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(sql).collect do |student|
      Student.new_from_db(student)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade <= 11
    SQL
    DB[:conn].execute(sql).collect do |student|
      Student.new_from_db(student)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY name LIMIT ?
    SQL
    DB[:conn].execute(sql, x).collect do |student|
      Student.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY id LIMIT 1
    SQL
    DB[:conn].execute(sql).collect {|student|Student.new_from_db(student)}[0]
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql, x).collect {|students| Student.new_from_db(students)}
  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
