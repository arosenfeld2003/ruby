def my_csv_parser(a, b)
  return a.split("\n").collect { |row| row.split(b) }
end

# "a,b,c,e\n1,2,3,4\n" && "," ==>
# [["a", "b", "c", "e"], ["1", "2", "3", "4"]]

