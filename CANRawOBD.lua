function CANRxHandler(MsgID, IDType, FrameType, data, DLC, ErrorStatus,FDFormat, BRS)

	print(string.format("Rx MsgID %x Len %d RspType %x  Param %x  Val %d", MsgID, string.byte(data, 1), string.byte(data, 2), string.byte(data ,3), string.byte(data, 4)))
	
end

function ButtonHandler(id, state)
	if state==2 then
		-- OBD Request Packet Format:   <len=2><mode=1><param=0x0d=speed>  0c=rpm   01=DTC Status
		data=string.char(2) .. string.char(1) .. string.char(0x01)
		
		--MsgID, IDType=0=11-bit, data, dataLen (always 8 for OBD--data is 0-padded), portno, frametype (0=data frame; RTR Frame not used in OBD)
		ez.CANBusTx(0x07df, 0, data, 8, 1, 0)
	end
	ez.Button(id, state)
end

function mainFunction()
	ez.CANBusOpen(1,8,0,0,1,0,1,3,8,0,8,3,8,1)

	ez.CANBusRegisterHandler(0, "CANRxHandler")
	ez.CANBusGlobalFilter(2,2,1,1)
	ez.CANBusConfigFilter(1, 0, 0, 1, 1, 0x07e8, 0x07e8)
	ez.CANBusStart(1)
	
	ez.Cls(ez.RGB(255,255,255))
	ez.SetColor(ez.RGB(0,0,0))
	ez.Button(0, 1, 0, 1, -1, 100, 100)
	ez.SetButtonEvent("ButtonHandler")
	while (true) 
	do
		-- blink(1) -- blink led and wait 1 seconds before sending more data
	end 
	
end

function errorHandler(errmsg)
    print(debug.traceback())
    print(errmsg)
end

-- Call mainFunction() protected by errorHandler
rc, err = xpcall(function() mainFunction() end, errorHandler)