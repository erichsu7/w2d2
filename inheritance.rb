class Employee

  attr_reader :salary, :name

  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
    @boss = nil
  end

  def bonus(multiplier)
    @salary * multiplier
  end

end

class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary)
    super
    @employees = []
  end

  def bonus(multiplier)
    return 0 if employees.empty?
    bonus_base = 0

    employees.each do |employee|
      bonus_base += employee.salary
      bonus_base += employee.bonus(1) if employee.is_a?(Manager)
    end

    bonus_base * multiplier
  end
end


ned = Manager.new("Ned", "Founder", 1000000)
darren = Manager.new("Darren", "TA Manager", 78000)
shawna = Employee.new("Shawna", "TA", 12000)
david = Employee.new("David", "TA", 10000)

ned.employees << darren
darren.employees << shawna
darren.employees << david

# p darren.get_salaries

p ned.bonus(5)
p darren.bonus(4)
p david.bonus(3)
