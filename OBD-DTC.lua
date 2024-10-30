function ButtonHandler(id, state)
	if state==2 then
		if id==0 then
			ln, dtc=ez.OBDGetDTC()
			if ln == -1 then 
				print("Timeout")
			else
				for i=1,ln 
				do
					print(dtc[i])
				end
			end
		end
		if id==1 then
			ez.OBDClearDTC()
			print("DTCs Cleared")
		end
	end
	ez.Button(id, state)
end

function mainFunction()
	ez.OBDOpen(1,8)
	
	ez.Cls(ez.RGB(255,255,255))
	ez.SetColor(ez.RGB(0,0,0))

	ez.Button(0, 1, 0, 1, -1, 100, 100)
	ez.Button(1, 1, 0, 1, -1, 100, 200)
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