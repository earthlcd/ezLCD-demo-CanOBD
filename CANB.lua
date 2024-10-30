-- function CANRxHandler(MsgID, IDType, FrameType, data, DLC, ErrorStatus, FDFormat, BRS)
	

	-- print(string.format("Rx MsgID %x Len %d RspType %x  Param %x  Val %d", MsgID, string.byte(data, 1), string.byte(data, 2), string.byte(data ,3), string.byte(data, 4)))
	-- ez.SetFtFont(0,10,10)
	-- ez.SetColor(ez.RGB(255,215,0))
	-- ez.SetXY(25, 25)
	-- print("Other words")
	-- print(ErrorStatus)
	-- print(data)
-- end

function ButtonHandler(id, state)
	if state==2 then
		-- OBD Request Packet Format:   <len=2><mode=1><param=0x0d=speed>  0c=rpm   01=DTC Status
		data=string.char(2) .. string.char(1) .. string.char(0x01)
		
		--MsgID, IDType=0=11-bit, data, dataLen (always 8 for OBD--data is 0-padded), portno, frametype (0=data frame; RTR Frame not used in OBD)
		ez.CANBusTx(0x07df, 0, data, 8, 1, 0)
	
	-- elseif state==1 then
	
	end
	-- ez.Button(id, state)
end

function mainFunction()
	ez.CANBusOpen(1,10,0,0,1,0,1,3,8,0,8,3,8)
	
	-- ez.CANBusRegisterHandler(0, "CANRxHandler", 1)
	ez.CANBusGlobalFilter(0,2,1,1,1)
	ez.CANBusConfigFilter(1, 0, 0, 1, 0, 0x07e8, 0x07e9, 0)
	ez.CANBusStart(1)
	
	ez.Cls(ez.RGB(255,255,255))
	ez.SetColor(ez.RGB(0,0,0))
	-- print(data)
	
	-- ez.Button(0, 1, 0, 1, -1, 10, 10)
	-- ez.SetButtonEvent("ButtonHandler")
	
	ez.SetColor(ez.RGB(224,224,224))
	ez.SetPenSize(8,8)
	ez.Circle(200, 140, 74)

	ez.SetColor(ez.RGB(0,0,0))
	ez.HLine(277, 140, 287)
	ez.HLine(113, 140, 123)
	ez.VLine(200, 53, 63)
	ez.VLine(200, 217, 227)
	
	-- ez.SetColor(ez.RGB(0,0,0))
	-- ez.SetXY(170,120)
	-- ez.SetFtFont(1,20,0)
	-- print("000")
	-- ez.SetPenSize(8,8)
	-- ez.SetColor(ez.RGB(0,0,255))
	-- ez.Arc(200, 140, 70, 0, 3072)
				
	while (true) 
	do
		ez.Wait_ms(500)

		MsgID,IDType,frameType,Data,Length,errStatus,ClassicFormat,BRS,filterMatch,filterIdx = ez.CANBusRx(64,1)
		if Data ~= nil then
				
			if string.byte(Data, 1) ~= nil then
				angle1 = string.byte(Data, 1)
				angle2 = string.byte(Data, 2)
				angle = angle1 + angle2
				
				arc= angle * 45
				
				ez.SetColor(ez.RGB(255,255,255))
				ez.SetXY(170,120)
				ez.SetBgColor(ez.RGB(255,255,255))
				ez.SetFtFont(1,40,0)
				print('               ')					

				ez.SetPenSize(8,8)
				ez.SetColor(ez.RGB(0,0,255))
				ez.Arc(200, 140, 74, 0, arc)
			
				ez.SetColor(ez.RGB(0,0,0))
				ez.SetXY(170,120)
				ez.SetFtFont(1,20,0)
				print(angle)

				if angle >= 359	then
					ez.Cls(ez.RGB(255,255,255))
					-- ez.Button(0, 1, 0, 1, -1, 10, 10)
					ez.SetColor(ez.RGB(224,224,224))
					ez.Circle(200, 140, 74)
					ez.SetPenSize(8,8)
					ez.SetColor(ez.RGB(0,0,0))
					ez.HLine(277, 140, 287)
					ez.HLine(113, 140, 123)
					ez.VLine(200, 53, 63)
					ez.VLine(200, 217, 227)
					ez.SetPenSize(8,8)
				end
				
			end 
		
		end
		ez.CANBusTx(0x07df, 0, data, 8, 1, 0)
		-- blink(1) -- blink led and wait 1 seconds before sending more data
	end 
	
end

function errorHandler(errmsg)
    print(debug.traceback())
    print(errmsg)
end

-- Call mainFunction() protected by errorHandler
rc, err = xpcall(function() mainFunction() end, errorHandler)