# frozen_string_literal: true

require 'date'
require 'csv'

# The student class
class Student
  attr_reader :last_name, :first_name, :patronymic, :date_of_birth, :gender, :school_class, :educational_institution

  def initialize(last_name, first_name, patronymic, date_of_birth, gender, school_class, educational_institution)
    @last_name = last_name
    @first_name = first_name
    @patronymic = patronymic
    @date_of_birth = Date.strptime(date_of_birth, '%Y-%m-%d')
    @gender = gender
    @school_class = school_class
    @educational_institution = educational_institution
  end

  def full_name
    "#{@last_name} #{@first_name} #{@patronymic}"
  end
end
