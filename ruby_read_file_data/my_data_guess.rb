# require_relative 'helpers.rb'
def my_csv_parser(a, b)
  return a.split("\n").collect { |row| row.split(b) }
end

def getFileData(fileName)
  @dataObject
  file = File.read(fileName)
  fileData = file.read
  dataObject = my_csv_parser(fileData, ',')
  file.close
  return dataObject
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
  print dataSummary
  return dataSummary
end

def analyzeData(dataSummary)
  columnTitle = ''
  columnValue = ''
  highestFrequency = 0
  dataSummary.each do |column|
    entries = column[1..-1]
    entries.each do |entry|
      if entry[1] > highestFrequency
        columnTitle = column[0]
        columnValue = column[1]
        highestFrequency = entry[1]
      end
    end
  end
  mostLikelyCustomer = [columnTitle, columnValue[0]]
  return mostLikelyCustomer
end

def my_data_guess(file)
  dataObject = my_csv_parser(file, ',')
  columnTitles = dataObject.shift
  dataSummary = createDataSummary(columnTitles, dataObject)
  return analyzeData(dataSummary)
end

# print my_data_guess(File.read("my_online_coffee_store_example_1.csv"))