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
      customer[4] = email
    end
  end
end

def transformAge(customer)
  ageGroups = ["1->20", "21->40", "41->65", "66->99"]
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
    timeGroup = "morning"
  when 12..17
    timeGroup = "afternoon"
  when 18..23
    timeGroup = "evening"
  end
  customer[9] = timeGroup
end

def transformData(dataObject)
  columnTitles = dataObject.shift
  dataObject.each do |customer|
    transformEmail(customer)
    transformAge(customer)
    transformTime(customer)
  end
  dataObject.unshift(columnTitles)
  dataObject.collect {|arr| arr.join(',')}
end

def my_data_transform(file)
  dataObject = my_csv_parser(file, ',')
  return transformData(dataObject)
end

# print my_data_transform(File.read("coffee_customer_data.csv"))

# ["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,41->65,Chicago,ChromeAndroid,1,afternoon"]
# ["Gender,FirstName,LastName,UserName,Email,Age,City,Device,Coffee Quantity,Order At", "Male,Carl,Wilderman,carl,yahoo.com,21->40,Seattle,Safari iPhone,2,afternoon", "Male,Marvin,Lind,marvin,hotmail.com,66->99,Detroit,Chrome Android,2,afternoon", "Female,Shanelle,Marquardt,shanelle,hotmail.com,21->40,Las Vegas,Chrome,1,afternoon", "Female,Lavonne,Romaguera,lavonne,yahoo.com,66->99,Seattle,Chrome,2,morning", "Male,Derick,McLaughlin,derick,hotmail.com,40->65,Chicago,Chrome Android,1,afternoon"]