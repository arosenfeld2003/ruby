def move_robot(instructions, directions)
  heading = 0
  x = 0
  y = 0
  bearing = directions[0]

  instructions.each_char do |char|
    if char == "R"
      heading == 3 ? heading = 0 : heading += 1
    elsif char == "L"
      heading == 0 ? heading = 3 : heading = heading - 1
    elsif char == "A"
      case heading
      when 0
        y -= 1
      when 1
        x += 1
      when 2
        y += 1
      when 3
        x -= 1
      end
    else
      return "invalid instructions"
    end
    bearing = directions[heading]
  end
  # "{x: %{x}, y: %{y}, bearing: '%{bearing}'}" % hash
  return "{x: #{x}, y: #{y}, bearing: '#{bearing}'}"
end


def my_robot_simulator(instructions)
  # use array indices to access each direction.
  directions = ["north", "east", "south", "west"]
  return move_robot(instructions, directions)
end

# puts my_robot_simulator("RAALALL")
# puts my_robot_simulator("AAAA")
# puts my_robot_simulator("RAARA")