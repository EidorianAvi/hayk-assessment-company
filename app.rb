class Company
    
    attr_accessor :name, :number_of_employees, :id

    def initialize name, number_of_employees, id = nil
        @name = name
        @number_of_employees = number_of_employees 
        @id = id
    end

    def self.create_table
        sql = <<-SQL 
          CREATE TABLE IF NOT EXISTS companies (
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          number_of_employees INTEGER
          );
          SQL
      DB[:conn].execute(sql) 
    end

    def self.new_from_db(row)
        company = self.new
        company.id = row[0]
        company.name = row[1]
        company.number_of_employees = row[2]
        company
      end

    def save
        sql = <<-SQL
            INSERT INTO companies (name, number_of_employees) VALUES(?, ?);
        SQL

        DB[:conn].execute(sql, self.name, self.number_of_employees)
        @id  = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

    def self.find_by_name name 
        sql = <<-SQL
          SELECT *
          FROM companies
          WHERE name = ?
          LIMIT 1;
        SQL
      
      DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
      end.first
    end

    def self.all
        sql = <<-SQL
          SELECT *
          FROM companies;
        SQL
        
        DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
        end
    end

    def update
        sql = <<-SQL
        UPDATE companies
        SET name = ?, number_of_employees = ?
        WHERE id = ?
        SQL
        
        DB[:conn].execute(sql, self.name, self.number_of_employees, self.id)
    end

      
    def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS companies;
        SQL
    
        DB[:conn].execute(sql)
    end
    
end