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
  # dataObject.collect {|arr| arr.join(',')}
  return dataObject
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
      num != nil ? num += 1 : num = 1
      newHash = {"#{dataPoint}": num}
      categoryHash.merge!(newHash)
      dataHash.merge(categoryHash)
    end
  end
end

# columnTitles array is the first row of dataObject
# data is all subsequent rows containing the values
def createDataSummary(columnTitles, data)
  dataSummary = []
  columnTitles.each_with_index {|title, index| dataSummary[index] =["#{title}"]}
  data.each_with_index do |customer, dataIndex|
    customer.each_with_index do |data, customerIndex|
      newEntry = []
      dataEntry = "#{customer[customerIndex]}"
      newEntry.push("#{dataEntry}", 1)
      dataSet = dataSummary[customerIndex][1..-1]
      entryExists = false
      dataSet.each do |entry|
        if entry[0] == dataEntry
          entry[1] += 1
          entryExists = true
          break
        end
      end
      if !entryExists
        dataSummary[customerIndex].push(newEntry)
      end
    end
  end
  return dataSummary
end

def my_data_process(dataArr)
  columnTitles = dataArr.shift
  return processData(columnTitles, dataArr)
end

def makeHash(dataSummary)
  processedDataHash = {}
  dataSummary.each do |data|
    category = data[0]
    if category == "Order At" || category == "Gender" ||
        category == "Email" || category == "Age"
      valueHash = {}
      data.shift
      data.each do |value|
        valueHash.merge!({"#{value[0]}": value[1]})
      end
      processedDataHash["#{category}"] = valueHash
    end
  end
  return "#{processedDataHash}".to_json
end

def my_data_extract(data)
  processedDataStr = JSON.parse(data)
  processedData = eval(processedDataStr)
  extractedData = []
  columns = processedData.keys
  mostFrequent = []
  processedData.each_with_index do |category, columnIndex|
    results = category[1]
    highCount = 0
    value = ""
    results.each do |valuesObj|
      if valuesObj[1] > highCount
        value = "#{valuesObj[0]}"
        highCount = valuesObj[1]
      end
    end
    columnName = columns[columnIndex]
    hash = {"column_name": "#{columnName}", "value": "#{value}", "nbr_of_occurence": highCount}
    extractedData.push(hash)
  end
  return extractedData
end

# dataObject = my_csv_parser(File.read("customerData03.csv"), ',')
# transformData(dataObject)
# columnTitles = dataObject.shift
# dataSummary = createDataSummary(columnTitles, dataObject)
# processedData = makeHash(dataSummary)
# print my_data_extract(processedData)

