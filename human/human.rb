$LOAD_PATH << '.'
require 'txt_reader.rb'

class Human

  # @@AGE_LIMIT: There is the limitation of the age you want to
  # filter.
  @@AGE_LIMIT = 18

  attr_reader :name, :age, :gender

  # @@array_human: this is used for store list of people
  @@array_human = []

  # @@keys_array. It is an array of attribute of a person
  # it is used for write data to file 
  @@keys_array = [:name,:age,:gender]
  

  def initialize(name, age, gender)
    @name, @age, @gender = name, age, gender
  end

  def self.keys_array
    @@keys_array
  end

  # method to get value of @@array_human
  def self.array_human
    @@array_human
  end

  def self.find_people_by_gender(arr_person, gender) 
    arr_person.select { |person| person.gender.downcase == gender.downcase }
  end

  def self.find_persons_under_age(arr_person, age)
    arr_person.select { |person| person.age < @@AGE_LIMIT }
  end

  def self.find_persons_older_age(arr_person, age)
    arr_person.select { |person| person.age >= @@AGE_LIMIT }
  end

  # method to display all people on this arr_person list
  def self.display_list_people_information(arr_person)
    arr_person.each { |person| puts person.description } 
  end

  def self.print_star
    puts "********************************************************"
  end

  # check amount of list_person list 
  # if this amount > 0, then display list of person
  # unless display "0"
  def self.check_amount(list_person)
    if (list_person.size > 0)
      display_list_people_information(list_person)
    else
      puts "0"
    end
  end

  # check valid person information
  # return true if all information are valids,
  # unless return false.
  def self.valid_input_hash_person?(person_hash)
    return false unless self.valid_name?(person_hash[:name])
    return false unless self.valid_gender?(person_hash[:gender])
    return false unless self.valid_age?(person_hash[:age])
    true  
  end

  def self.valid_name?(name)
    (name.is_a?(String)) && (name.delete(" ") != "")
  end

  def self.valid_gender?(gender)
    return false unless (gender.is_a?(String))
    (gender.downcase == 'male') || (gender.downcase == 'female')
  end

  def self.valid_age?(age)
    (age.is_a?(Integer)) && age > 0 && age <= 100
  end

  def self.display_result
    self.print_star
    puts "List of female person in your list: "
    list_female = self.find_people_by_gender(@@array_human, "female")
    self.check_amount(list_female)

    list_of_people_under_age = 
          self.find_persons_under_age(@@array_human, $AGE_LIMIT)
    list_of_people_older_age = 
          self.find_persons_older_age(@@array_human, $AGE_LIMIT)

    puts "List of female person is younger #{@@AGE_LIMIT} in your list: "
    list_female_younger =  
          self.find_people_by_gender(list_of_people_under_age, "female")
    self.check_amount(list_female_younger)

    puts "List of female person is older than #{@@AGE_LIMIT} in your list: "
    list_female_older = 
          self.find_people_by_gender(list_of_people_older_age, "female")
    self.check_amount(list_female_older)

    self.print_star
    puts "List of male person in your list: "
    list_male = self.find_people_by_gender(self.array_human, "male")
    self.check_amount(list_male) 

    puts "List of male person is younger #{@@AGE_LIMIT} in your list: "
    list_male_younger = 
          self.find_people_by_gender(list_of_people_under_age, "male")
    self.check_amount(list_male_younger)

    puts "List of male person is older than #{@@AGE_LIMIT} in your list: "
    list_male_older = 
          self.find_people_by_gender(list_of_people_older_age, "male")
    self.check_amount(list_male_older)
  end

  def self.read_data_from_hash_array(array_of_hash_people)
    array_of_hash_people = self.normalize_data_type(array_of_hash_people)
    array_of_hash_people.each do |person_hash|
      # check if invalid person information then do not add into @@array_human
      if self.valid_input_hash_person?(person_hash)
        @@array_human << Human.new(person_hash[:name], person_hash[:age], 
            person_hash[:gender])
      end
    end
  end

  # normalize_data_type it used for convert age from string to integer in hash
  def self.normalize_data_type(array_of_hash_people)
    array_of_hash_people.each do |hash_person|
      begin
        hash_person[:age] = hash_person[:age].to_i
      rescue
        array_of_hash_people.delete(hash_person)
      end
    end
    array_of_hash_people
  end

  #description. This return a string which decribe a people
  def description
    "Name: #{@name}, age: #{@age}, gender: #{@gender}"
  end

end
# main
my_reader = TxtReader.new("input_human.txt")
array_of_person_hash = my_reader.read_data_from_file_to_array_of_hash(Human.keys_array)
Human.read_data_from_hash_array(array_of_person_hash)
# display result
Human.display_result

