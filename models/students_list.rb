# frozen_string_literal: true

require_relative 'student'

# The students list class
class StudentList
  def initialize(students = [])
    @students = students
  end

  def add_student(student)
    @students.append(student)
  end

  def list_schools
    @students.map(&:educational_institution)
             .uniq
             .sort_by { |s| [s.split[0], s.split[1].sub('№', '').to_i] }
             .map.with_index { |s, i| [i + 1, s] }.to_h
  end

  def list_schools_by_type(school_type)
    case school_type
    when 'school'
      list_schools.select { |_, s| s.split[0].include?('Школа') }
    when 'lyceum'
      list_schools.select { |_, s| s.split[0].include?('Лицей') }
    when 'gymnasium'
      list_schools.select { |_, s| s.split[0].include?('Гимназия') }
    else
      []
    end
  end

  def students_by_school(school_name)
    @students.select { |s| s.educational_institution == school_name }
  end

  def students_by_school_class(school_name, school_class, with_letter = '')
    school_class_students = @students.select do |s|
      s.educational_institution == school_name &&
        s.school_class == school_class &&
        s.last_name[0].include?(with_letter)
    end
    school_class_students.sort_by { |s| [s.last_name, s.first_name, s.patronymic] }
  end

  # @param asc: 1 - sort by ascending, -1 - sort by descending
  def school_by_id(school_id, asc = 1)
    school_name = list_schools[school_id]
    students_school = students_by_school(school_name)
    list_classes = students_school.map(&:school_class)
                                  .uniq
                                  .sort_by { |s| [asc * s.scan(/\d+/).first.to_i, s[-1]] }
                                  .map.with_index { |s, i| [i + 1, s] }.to_h
    {
      school_name: school_name,
      count_boys: students_school.count { |s| s.gender == 'мужской' },
      count_girls: students_school.count { |s| s.gender == 'женский' },
      total_count: students_school.size,
      list_classes: list_classes
    }
  end

  def read_in_csv_data(file_name)
    CSV.foreach(file_name) do |row|
      student = Student.new(row[0], row[1], row[2], row[3], row[4], row[5], row[6])
      add_student(student)
    end
  end
end
