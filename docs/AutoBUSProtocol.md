START | FRAME TYPE (2 bytes) | DATA BYTES LENGTH (depend on frame type, DATA BYTES only) | ... | STOP

FRAME TYPE : 0 => PROTOCOL VERSION NEGOTIATION
	... ROUTER / WORKER VERSION NUMBER (2 bytes)
	(data bytes length : 0 bytes)

FRAME TYPE : 10 => INSTALL APPLICATION (with frame part concatenation => 1Tbytes max)
	... TOTAL FRAMES NESTED (2 bytes, only on first frame part) / FRAME COUNT (2 bytes, after first frame part) | DATA BYTES (data bytes length : 3 bytes) ...

FRAME TYPE : 100 => TASKS HEARTBEAT




FRAME TYPE : 200 => TASKS EVENT
	... EVENT ID (4 bytes, if exceed then back to 0) | DATA BYTES (2 bytes, if event take more than 2 bytes length => BIG EVENT) ...
	
	DATA BYTES are json format without whitespace
		{
			APP_NAME: "...",
			EVENT_NAME: "...",
			EVENT_PARAMETERS [
				{
					"(parameter name)": "(parameter data)",
					...
				}
			]
		}

FRAME TYPE : 201 => TASKS BIG EVENT
	... EVENT ID (4 bytes, if exceed then back to 0) | DATA BYTES (3 bytes, if event take more than 3 bytes length => MASSIVE EVENT) ...
	
	DATA BYTES same as EVENT (event type : 2)

FRAME TYPE : 202 => TASKS MASSIVE EVENT (it make no sens but we never know)
	... EVENT ID (4 bytes, if exceed then back to 0) | DATA BYTES (4 bytes) ...
	
	DATA BYTES same as EVENT (event type : 2)
	


