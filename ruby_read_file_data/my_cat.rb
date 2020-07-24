class My_cat
  for arg in ARGV
    file = File.open("#{arg}")
    fileData = file.read
    puts fileData
    file.close
  end
end

My_cat.new