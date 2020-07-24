# We have been provided a dataset of sales from My Online Coffee Shop. It's a CSV (Comma Separated Values) (each columns are separated by , and each line by \n)
# Our goal will be to identify customer who are more likely to buy coffee online.

# Ok, this time we will have to create a function with code logic, with data, we don't guess so this time the goal is not to return the solution hard coded. :D

# Data management is hard problem, as hard problem we have to split them into smaller one.

# Here is our first step: data prep.

# You noticed our CSV is composed of 3 columns we cannot group them easily: Email - Age - Order At.

# For the email, we will consider the provider.
# For the age column, we consider a group from [1->20] - [21->40] - [41->65] - [66->99]
# For the Order at column, we consider a group for [morning => 06:00am -> 11:59am] - [afternoon => 12:00pm -> 5:59pm] - [evening => 6:00pm -> 11:59pm]

# You will have to create a function which will replace the value in each of this column with the correct actionable data.
# (ex: if the age is between 21 and 40, replace by "21->40")

# Order At is a little more tricky.

# Your function will be prototyped: def my_data_transform(csv_content)
# It will take a string which contains data in CSV format and it will return a string in CSV format with the column Email, Age and Order At transformed.

require 'date'

def my_csv_parser(a, b)
  return a.split("\n").collect { |row| row.split(b) }
end

def transformEmail(customer)
  emailCharArray = customer[4].split('')
  emailCharArray.each_with_index do |char, index|
    if char == '@'
      emailCharArray.shift(index + 1)
      email = emailCharArray.join('')
      case email
      when "gmail.com"
        groupNum = 0
      when "hotmail.com"
        groupNum = 1
      when "yahoo.com"
        groupNum = 2
      end
      customer[4] = groupNum
    end
  end
end

def transformAge(customer)
  ageGroups = [0, 1, 2, 3]
  age = customer[5].to_i
  ageRange = " "
  case age
  when 1..20
    ageRange = ageGroups[0]
  when 21..40
    ageRange = ageGroups[1]
  when 41..65
    ageRange = ageGroups[2]
  when 66..99
    ageRange = ageGroups[3]
  end
  customer[5] = ageRange
end

def transformTime(customer)
  timeGroup = ""
  orderTime = DateTime.parse(customer[9])
  case orderTime.hour
  when 6..11
    timeGroup = 0
  when 12..17
    timeGroup = 1
  when 18..23
    timeGroup = 2
  end
  customer[9] = timeGroup
end

def transformQuantity(customer)
  quantity = customer[8].to_i
  case quantity
  when 1
    group = 0
  when 1..4
    group = 1
  end
  if quantity >= 4
    group = 2
  end
  customer[8] = group
end

def transformGender(customer)
  gender = customer[0]
  case gender
  when "Male"
    val = 1
  when "Female"
    val = 0
  end
  customer[0] = val
end

def transformCity(customer)
  city = customer[6]
  cities = [{
    "Austin" => "0",
    "Charlotte" => "1",
    "Chicago" => "2",
    "Columbus" => "3",
    "Dallas" => "4",
    "Fort Worth" => "5",
    "Houston" => "6",
    "Indianapolis" => "7",
    "Jacksonville" => "8",
    "Los Angeles" => "9",
    "New York" => "10",
    "Philadelphia" => "11",
    "Phoenix" => "12",
    "San Antonio" => "13",
    "San Diego" => "14",
    "San Francisco" => "15",
    "San Jose" => "16",
    "Seattle" => "17"
  }]

  cities.each do |city_code|
    if city_code.has_key?(city)
      customer[6] = city_code[city]
    end
  end
end

def transformDevice(customer)
  device = customer[7]
  device_codes = [{
    "Chrome" => "0",
    "Firefox" => "1",
    "Safari" => "2"
  }]
  device_codes.each do |devices|
    if devices.has_key?(device)
      customer[7] = devices[device]
    end
  end
end

def transformData(dataObject)
  columnTitles = dataObject.shift
  dataObject.each do |customer|
    transformEmail(customer)
    transformAge(customer)
    transformTime(customer)
    transformQuantity(customer)
    transformGender(customer)
    transformCity(customer)
    transformDevice(customer)
    customer.delete_at(3)
    customer.delete_at(2)
    customer.delete_at(1)
  end
  columnTitles.delete_at(3)
  columnTitles.delete_at(2)
  columnTitles.delete_at(1)
  dataObject.unshift(columnTitles)
  dataObject.collect {|arr| arr.join(',')}
end

def my_corr_data_transform(file)
  dataObject = my_csv_parser(file, ',')
  return transformData(dataObject)
end

# print my_corr_data_transform(File.read("data.csv"))
# ["Gender,Email,Age,City,Device,Coffee Quantity,Order At"]
