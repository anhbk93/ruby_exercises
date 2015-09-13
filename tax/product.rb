$LOAD_PATH << '.'
require 'txt_reader.rb'

class Product
  
  attr_reader :amount, :name, :price

  # @@array_products : it is used for save an array of product object
  @@array_products = []

  # @@new_array_products: it is used for save the new array of product object
  # after adding tax
  @@new_array_products = []

  # @@free_basic_tax_list: it includes list key word, which product name have that
  # will be fee basic tax
  @@free_basic_tax_list = ["food", "book", "medicine"]

  # @@notes: it's used for saving data notes to write to file
  @@notes = []

  def initialize(amount, name, price)
    @amount, @name, @price = amount, name, price
  end

  # price setter
  def price=(value)
    @price = value
  end

  # @@notes getter
  def self.notes
    @@notes
  end

  # check product if it is included free basic tax return false
  # if not return true
  def not_free_basic_tax? free_basic_tax_list
    free_basic_tax_list.each do |key|  
      return false if (self.name.downcase.include?(key.downcase))
    end
    true
  end

  # check product if it is included import tax return true
  # if not return false
  def import_tax?
    @name.downcase.start_with?("import")
  end

  # Description a product
  #return a string with product description
  def description
    sprintf('%5d %20s %10.2f',@amount, @name, @price.round(2))
  end

  # this method is used for rounding price of product
  def round
    self.price = self.price.round(2) 
    self
  end

  # increase_product_fee products_list: it's used for adding tax to each product
  # in products_list with basic and import tax
  def self.increase_product_fee(products_list)
    products_list.each do |product|
      plus_basic_tax(product) if product.not_free_basic_tax?(@@free_basic_tax_list)
      plus_import_tax(product) if product.import_tax?
      @@new_array_products << product.round
    end
  end

  # valid_input_array_product? product_array: it is used for validating
  # data each product_array = [amount, "name", price]
  def self.valid_input_array_product?(product_array)
    return false unless self.valid_name?(product_array[1])
    return false unless self.valid_amount?(product_array[0])
    return false unless self.valid_price?(product_array[2])
    true  
  end

  def self.valid_name?(name)
      (name.is_a? String) && (name.delete(" ") != "")
  end

  def self.valid_amount?(amount)
    (amount.is_a? Integer) && (amount >= 0)
  end

  def self.valid_price?(price)
    (price.is_a? Float) && price >= 0.0 
  end

  def self.print_star
    puts "*************************************"
  end

  # plus_basic_tax product:it's used for adding basic tax of product
  # with formular: sum = sum + 0.1*sum
  def self.plus_basic_tax(product)
    product.price *= 1.1 
  end

  # plus_import_tax product: it's used for adding import tax of product
  # with formular: sum = sum + 0.05 * sum
  def self.plus_import_tax(product)
    product.price *= 1.05
  end

  # count_sum_of_fee products_list: it's used to count sumary of fee
  # that you must pay.
  def self.count_sum_of_fee(products_list)
    sum  = 0
    products_list.map { |product| sum += product.amount * product.price }
    sum
  end

  # title_of_product_table: this method returns titles of product
  # table, if you want to display to user
  def self.title_of_product_table
    sprintf("%5s %20s %10s \n", "Number", "Name", "Price")
  end

  # print_table_product arr_product: it's used for printing product
  # table
  def self.print_table_product(arr_product)
    puts self.title_of_product_table
    arr_product.each { |product| puts product.description }
  end

  # self.normalize_data_type array_of_array_products
  # this method is used for adjust data type to adapt
  # for some attribute of product object
  def self.normalize_data_type(array_of_array_products)
    array_of_array_products.each do |array_product|
      begin
        array_product[0] = array_product[0].to_i
        array_product[2] = array_product[2].to_f.round(2)
      rescue
        array_of_array_products.delete(array_product)
      end
    end
      array_of_array_products
  end

  # read_data_from_array_of_array array_of_array_products 
  # this method is used for reading data from out put of the file
  # and save it in to an array of product object
  def self.read_data_from_array_of_array(array_of_array_products)
    array_of_array_products = self.normalize_data_type(array_of_array_products)
    array_of_array_products.each do |array_product|
      #check if invalid product information then do not add it into @@arr_product
      if self.valid_input_array_product?(array_product)
        @@array_products << Product.new(array_product.shift, array_product.shift, array_product.shift)     
      end
    end
    @@array_products
  end

  # convert_data_type_to_save_to_file products_array
  # this method is used for converting data from array of product object
  # to array of product attributes array to write to file
  def self.convert_data_type_to_save_to_file(products_array)
    result_array =[]
    products_array.each do |product|
      result_array << [product.description]
    end
    result_array
  end

  # main_function array_of_array_products
  # it includes a list of method to display information to
  # user
  def self.main_function array_of_array_products
    self.read_data_from_array_of_array(array_of_array_products)
    sum_before = self.count_sum_of_fee(@@array_products)
    puts "List of product input without tax:"
    self.print_table_product @@array_products
    self.print_star
    puts "List of product output with tax :"
    self.increase_product_fee @@array_products
    self.print_table_product @@array_products
    self.print_star
    @@sum_fee = self.count_sum_of_fee @@new_array_products
    @@sum_tax = @@sum_fee - sum_before
    print_sum_of_tax = "Sum of tax: $#{@@sum_tax.round(2)}"
    print_sum_of_fee = "Sum of fee: $#{@@sum_fee.round(2)}"
    @@notes.push(print_sum_of_tax,print_sum_of_fee)

    puts print_sum_of_tax
    puts print_sum_of_fee

    #finally, convert data type to write to file
    self.convert_data_type_to_save_to_file(@@new_array_products)
  end
end

#main
read_file = TxtReader.new("input_products.txt")
array_result = Product.main_function(read_file.read_data_from_file_to_array_of_array)
puts 'Do you want to save to file? Input "yes" or "y" to save another key to abort.'
key = gets.chomp
if key.downcase != 'yes' && key.downcase != 'y'
  puts "Exited without save to file."
else
  puts "Input file name you want to save it into."
  file_name = gets.chomp
  write_to_file = TxtReader.new(file_name)
  write_to_file.write_data_to_file(array_result, Product.title_of_product_table, Product.notes)
end