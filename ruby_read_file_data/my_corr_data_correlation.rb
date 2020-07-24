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

def my_pearson_correlation(x, y)
  n = x.length

  sum_x = x.inject(0) { |r, i| r + i }
  sum_y = y.inject(0) { |r, i| r + i }

  sum_x_sq = x.inject(0) { |r, i| r + i ** 2 }
  sum_y_sq = y.inject(0) { |r, i| r + i ** 2 }

  prods = []
  x.each_with_index{ |this_x, i| prods << this_x * y[i] }
  p_sum = prods.inject(0) { |r, i| r + i }

  # Calculate Pearson score
  num = p_sum - (sum_x * sum_y / n)
  den = ((sum_x_sq - (sum_x ** 2) / n) * (sum_y_sq - (sum_y ** 2) / n)) ** 0.5
  if den == 0
    return 0
  end
  r = num / den
  return r
end

# def calculate_mean(arr, n)
#   return arr.inject(:+).to_f / n
# end

# def my_pearson_correlation(arr1, arr2)
#   if arr1.length != arr2.length
#     throw "Pearson Correlation Error: arrays must be equal size"
#   end
#   n = arr1.length
#   mean1 = calculate_mean(arr1, n)
#   mean2 = calculate_mean(arr2, n)

#   numerator = 0.0
#   dSquared1 = 0.0
#   dSquared2 = 0.0
#   denominator = 0.0

#   i = 0
#   while i < n
#     numerator += (arr1[i] - mean1) * (arr2[i] - mean2)
#     dSquared1 += ((arr1[i] - mean1)**2)
#     dSquared2 += ((arr2[i] - mean2)**2)
#     i += 1
#   end

#   denominator = Math.sqrt(dSquared1 * dSquared2)
#   return (numerator / denominator)
# end

def createDataArrays(transformedData)
  categorizedData = []
  categoryArrays = []
  columnTitles = []
  transformedData.each do |dataStr|
    dataArr = dataStr.split(',')
    categoryArrays.push(dataArr)
  end
  i = 0
  while i < categoryArrays[0].length
    dataArr = []
    categoryArrays.each do |arr|
      dataArr.push(arr[i])
    end
    columnTitles.push(dataArr.shift)
    categorizedData.push(dataArr)
    i += 1
  end
  categorizedData.unshift(columnTitles)
  return categorizedData
end

def my_corr_data_correlation(transformedData)
  dataCorrelation = []
  categorizedData = createDataArrays(transformedData)
  columnTitles = categorizedData.shift
  columnTitles.unshift("Corr Column")
  columnTitles = columnTitles.join(',')
  categorizedData.each_with_index do |curr, index|
    currArr = curr.map(&:to_f)
    i = 0
    dataArr = []
    while i < categorizedData.length
      data = categorizedData[i].map(&:to_f)
      dataArr.push(my_pearson_correlation(currArr, data).round(1))
      i += 1
    end
    dataArr.unshift(index)
    dataCorrelation.push(dataArr.join(','))
  end
  dataCorrelation.unshift(columnTitles)
  return dataCorrelation
end

# transformedData = my_corr_data_transform(File.read("data1.csv"))
# print my_corr_data_correlation(transformedData)