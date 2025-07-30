Config = {}

-- Fleeca Delivery Job -- 

-- Location of the delivery job start, this will also be used to deliver the truck back later on.
Config.JobStart = vector3(247.54, 208.55, 110.28)

-- Delivery Locations
Config.DeliverCheckpoints = {
    [1] = { name = "Elgin Ave - Fleeca Bank", location = vector3(311.67, -283.42, 54.16) },
    [2] = { name = "Legion Square - Fleeca Bank", location = vector3(147.49, -1045.01, 29.37) },
    [3] = { name = "Hawick Ave - Fleeca Bank", location = vector3(-353.58, -54.21, 49.04) },
    [4] = { name = "Rockford Hills - Fleeca Bank", location = vector3(-1211.45, -335.44, 37.78) },
    [5] = { name = "Banham Canyon - Fleeca Bank", location = vector3(-2957.78, 481.59, 15.7) },
    [6] = { name = "Route 68 - Fleeca Bank", location = vector3(1176.23, 2711.71, 38.09) },
    [7] = { name = "Paleto Bay - Fleeca Bank", location = vector3(-104.7, 6472.24, 31.63) }
}

-- Number of people needed to start a job. (COMING SOON)
-- Config.RequiredPeople = 2

-- Delivery Truck.
Config.DeliveryTruck = 'stockade' 

-- Time for delivery job to expire. (IN MINUTES) 
Config.JobTimer = 25 

-- Amount of drops that can be made in one job. (Do NOT exceed the table size `DeliverCheckpoints` or it will break)
Config.MaxDrops = 2

-- Delivery Truck Return Zone
Config.DeliveryReturn = vector3(331.19, 264.49, 104.03)

