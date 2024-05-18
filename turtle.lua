keep_stone = false
inventory_space = 16

forwards = 0
turns = 0
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

function mine(forward, left, down)
  if checkFuel() == false then
    return
  end

  local last_turn_was_left = false

  while downs <= down do
    while turns <= left do
      while forwards <= forward do
        if turtle.detect() == true then
          turtle.dig()
          if turtle.suck() then
            if keep_stone then 
              keepItem()          
            end
          else
            returnToStorage()         
          end
        end
        turtle.forward()
        forwards = forwards + 1
      end

      if not last_turn_was_left then
        turtle.turnLeft()
        if turtle.detect() == true then
          turtle.dig()
          
        end
        turtle.forward()
        turtle.turnLeft()
      else
        turtle.turnRight()
        if turtle.detect() == true then
          turtle.dig()
          if turtle.suck() then
            if keep_stone then 
              keepItem()          
            end
          else
            returnToStorage()         
          end
        end
        turtle.forward()
        turtle.turnRight()  
      end
      turns = turns + 1
    end

    turtle.digDown()
    if turtle.suckDown() then
      if keep_stone then 
        keepItem()          
      end
    else
      returnToStorage()         
    end
    turtle.down()
    turtle.turnLeft()

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
    if read() == 'y' then
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
