# KEY: I,   V,   X,   L,   C,   D,   M
#      1,   5,   10,  50, 100, 500, 1000

def convertDigitToNumeral(digit, index)
  returnStr = ""
  numerals = ["I", "V", "X", "L", "C", "D", "M"]
  case digit.to_i
  when 1..3
    i = 0
    while i < digit.to_i
      returnStr.concat("#{numerals[index]}")
      i += 1
    end
  when 4
    returnStr.concat("#{numerals[index]}#{numerals[index + 1]}")
  when 5
    returnStr.concat("#{numerals[index + 1]}")
  when 6..8
    returnStr.concat("#{numerals[index + 1]}")
    i = 0
    while i < (digit.to_i) - 5
      returnStr.concat("#{numerals[index]}")
      i += 1
    end
  when 9
    returnStr.concat("#{numerals[index]}#{numerals[index + 2]}")
  end
  return returnStr
end

def handleThousands(digit)
  str = ""
  i = 0
  while i < digit.to_i
    str.concat("M")
    i += 1
  end
  return str
end

def my_roman_numerals_converter(number)
  strNumReversed = "#{number}".reverse
  numeralsReversed = []
  strNumReversed.each_char.with_index do |digit, index|
    case index
    when 0
      numIndex = 0
    when 1
      numIndex = 2
    when 2
      numIndex = 4
    end

    if index != 3
      numeralsReversed.push(convertDigitToNumeral(digit, numIndex))
    else
      numeralsReversed.push(handleThousands(digit))
    end
  end
  return numeralsReversed.reverse.join('')
end

# puts my_roman_numerals_converter(14)
# puts my_roman_numerals_converter(79)
# puts my_roman_numerals_converter(845)
# puts my_roman_numerals_converter(2022)
# puts my_roman_numerals_converter(8)