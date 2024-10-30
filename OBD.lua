function ButtonHandler(id, state)
	if state==2 then
		-- Example OBD Request PIDs: <param=0x0d=speed>  0c=rpm   01=DTC Status
		-- See https://en.wikipedia.org/wiki/OBD-II_PIDs
		ln, data=ez.OBDGetPID(0x01)
		if ln>0 then
			if (data[1] & 0x80) == 0x80 then
				print("MIL Light ON")
			else	
				print("MIL Light OFF")
			end
			print(string.format("DTC Count=%d", data[1] & 0x7F))
		else
			print("Timeout getting DTC status")
		end
		ln, data=ez.OBDGetPID(0x0c)
		if ln>0 then
			print(string.format("RPM=%4.1f", ((256*data[1])+data[2])/4))
		end
		ln, data=ez.OBDGetPID(0xa6)
		if ln > 0 then
			print(string.format("Mileage=%7.1f", ((16777216 * data[1]) + (65536*data[2]) + (256 * data[3]) + data[4])/10))
		else
			print("Mileage not available (optional before 2019)")
		end
		
		ln, data=ez.OBDGetVehData(2)
		if ln >0 then
			VIN=""
			for i=1, 17 do
				VIN=VIN .. string.char(data[i])
			end
			print(string.format("VIN Number=%s", VIN))
		else
			print("Timeout getting VIN")
		end
		ln, data=ez.OBDGetVehData(0x0a)
		if ln >0 then
			ecu=""
			for i=1, 20 do
				ecu=ecu .. string.char(data[i])
			end
			print(string.format("ECU Name=%s", ecu))
		else
			print("ECU Name Not Available")
		end
		
	end
	ez.Button(id, state)
end

function mainFunction()
	ez.OBDOpen(1,8)
	
	ez.Cls(ez.RGB(255,255,255))
	ez.SetColor(ez.RGB(0,0,0))
	ez.Button(0, 1, 0, 1, -1, 100, 100)
	ez.SetButtonEvent("ButtonHandler")

	while (1) do
	end
	
end

function errorHandler(errmsg)
    print(debug.traceback())
    print(errmsg)
end

-- Call mainFunction() protected by errorHandler
rc, err = xpcall(function() mainFunction() end, errorHandler)