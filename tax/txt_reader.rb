class TxtReader

  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  # read data from file and save it into an array of object array data
  # to process
  def read_data_from_file_to_array_of_array
    begin
    data_rows = IO.readlines(@file_path)
    rescue
      puts "Unable to open file #{@file_path}"
      data_rows = []
    end
    data_array = []
    result_array = []
    if data_rows.size > 0
      data_rows.each { |row| data_array << row.to_s.chomp.split("---") }
      data_array.each do  |word| 
        result_array << [word.shift, word.shift, word.shift] 
      end
    end
    result_array
  end

  # read data from file and save it into an array of object hash to process
  def read_data_from_file_to_array_of_hash(keys_array)
    begin
    data_rows = IO.readlines(@file_path)
    rescue
      puts data_rows.size
      data_rows = []
    end
    data_array = []
    result_array = []
    if data_rows.size > 0
      data_rows.each { |row| data_array << row.to_s.chomp.split("---") }
      # data_array.each { |word| result_array << [word.shift,word.shift,word.shift] } 
      data_array.each do |data_row|
        my_hash = {}
        for i in 0..data_row.size - 1
          my_hash[keys_array[i]] = data_row[i]
        end
        result_array << my_hash
      end
    end
    result_array
  end


  # write data from array_data with title in title_string, and some note
  # will be printed in the end of file.
  def write_data_to_file(array_data, title_string, notes)
    my_file = File.new(@file_path, "w+")
    if my_file
      my_file.syswrite(title_string)
      array_data.each do |array_data|
        content = array_data.join("---")
        my_file.syswrite(content + "\n" )
      end

      notes.each { |data| my_file.syswrite(data + "\n") }

      puts "Success to write to file #{@file_path}"
    else
      puts "Unable to open file #{@file_path}!"
    end
  end

end
