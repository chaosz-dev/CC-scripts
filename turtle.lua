keep_stone = false
inventory_space = 16

distance_from_start = 0
forwards = 0
lefts = 0
downs = 0

function returnToStorage()
  checkFuel()

  local i = 0
  while i < downs do
    turtle.up()  
    i = i + 1
  end

  checkFuel()
  
  i = 0
  turtle.turnRight()
  while i < turns do
    turtle.forward()
    i = i + 1
  end

  checkFuel()

  i = 0
  turtle.turnRight()
  while i < forwards do
    turtle.forward()
    i = i + 1
  end

  i = 1
  while not (i > inventory_space) do
    turtle.select(i)
    table = turtle.getItemDetail(i)
    
    if table ~= nil then
      if table.tags ~= nil then
        if table.tags["minecraft:coal"] ~= nil then
            local chest = peripheral.find("minecraft:chest")
              turtle.drop()
        end
        i = i + 1
      end
    end
  end
end

-- checks fuel and refuels if needs be
function checkFuel()
    if turtle.getFuelLevel() < turtle.getFuelLimit() then
        local could_refuel = false
        local i = 1

        while not (i > inventory_space) do
            turtle.select(i)
            if turtle.refuel(0) then
                turtle.refuel()
                return true
            end
            i = i + 1
        end        
    end
    
    return false
end

function keepItem()
  local i = 1
        
  while not (i < inventory_space) do
      table = turtle.getItemDetail(i)
      if table.tags["minecraft:stone"] or table.tags["minecraft:stones"] then
        select(i)
        drop(i)
      end
      i = i + 1
  end        
end

function move(direction)
  local move_dir = {
    [0] = turtle.forward,
    [1] = turtle.down,
    [2] = turtle.up
  }

  local detect_dir = {
    [0] = turtle.detect,
    [1] = turtle.detectDown,
    [2] = turtle.detectUp
  }

  local dig_direction = {
    [0] = turtle.dig,
    [1] = turtle.digDown,
    [2] = turtle.digUp
  }

  if detect_dir[direction]() then
    dig_direction[direction]()
    turtle.suck()
  end
  move_dir[direction]()
end

function mine(forward, left, down)
  --[[
  if checkFuel() == false then
    print("Not enough fuel!")
    return
  end
  ]]

  while downs < down do

    local turn_left = true
    while lefts < left do

      while forwards < forward do
        move(0)
        forwards = forwards + 1
      end

      if turn_left then
        turtle.turnLeft()
      else
        turtle.turnRight()
      end

      move(0)
      
      if turn_left then
        turtle.turnLeft()
      else
        turtle.turnRight()
      end

      turn_left = not turn_left
      distance_from_start = distance_from_start + 1

    end

    move(1)
    distance_from_start = distance_from_start + 1

    downs = downs + 1
  end
end

-- start desired process 
function start()
    print("Welcome to m1n3rscr1pt.V1")
    print("Please make sure that there is a storage container behind the turtle before proceeding.")
    print("\nPress enter to proceed...")
    read()

    print("Should the miner keep stone items? y / n")
    if read() == "y" then
      keep_stone = true
    end


    print("Enter desired cube dimensions to be mined.")        
  
    write("Forward: ")
    local mine_forward = tonumber(read())
    if type(mine_forward) ~= "number" then
        printError("Please only input numbers!")
        return
    end
  
    write("Left: ")
    local mine_left = tonumber(read())
    if type(mine_left) ~= "number" then
        printError("Please only input numbers!")
        return
    end

    write("Down: ")
    local mine_down = tonumber(read())
    if type(mine_down) ~= "number" then
        printError("Please only input numbers!")
        return
    end
  
    mine(mine_forward, mine_left, mine_down)

end

start()
