require 'date'
require 'json'

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

def populateDataHash(dataHash, dataSummary)
  # dataHash => {Gender: {}, FirstName: {}, ...}
  # dataSummary => [{Gender: Male}, {FirstName: Alex}, ...]
  dataSummary.each do |obj|
    category = obj.keys[0]
    dataPoint = obj.values[0]
    categoryHash = dataHash["#{category}"]

    if categoryHash.empty?
      # first iteration: every categoryHash will be empty.
      newHash = {"#{dataPoint}": 1}
      categoryHash.merge!(newHash)
      dataHash.merge(categoryHash)
    else
      categoryHash.has_key?("#{dataPoint}")
      num = categoryHash[:"#{dataPoint}"]
      # Why nil check?  This confused me.
      num != nil ? num += 1 : num = 1
      newHash = {"#{dataPoint}": num}
      categoryHash.merge!(newHash)
      dataHash.merge(categoryHash)
    end
  end
end

def createDataSummary(columnTitles, data)
  dataSummary = []
  columnTitles = columnTitles.split(',')
  data = data.collect {|arr| arr.split(',')}
  # columnTitles array is the first row of dataObject
  # data is all subsequent rows containing the values
  data.each do |customer|
    customer.each_index do |index|
      dataSummary.push({"#{columnTitles[index]}": "#{customer[index]}"})
    end
  end

  for category in columnTitles
    dataHash = columnTitles.to_h {|category| [category, {}]}
  end

  populateDataHash(dataHash, dataSummary)

  dataHash.delete("FirstName")
  dataHash.delete("LastName")
  dataHash.delete("UserName")
  dataHash.delete("Coffee Quantity")
  return dataHash
end

def my_data_process(dataArr)
  columnTitles = dataArr.shift
  return createDataSummary(columnTitles, dataArr).to_json
end

# dataArr = my_data_transform(File.read("customerData.csv"))
# print my_data_process(dataArr)
