#include <Timer.h>
#include "TransmitTimer.h"

configuration TransmitTimerAppC{
}
implementation{
	
	components MainC;
	components TransmitTimerC as app;
	
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	
	components ActiveMessageC;
	components new AMSenderC(AM_TRANSMITTIMER);
	
	
	app.Boot -> MainC;
	
	app.Timer0 -> Timer0;
	app.Timer1 -> Timer1;
	
	app.AMControl -> ActiveMessageC;
	app.AMSend -> AMSenderC;
	app.Packet -> AMSenderC;
	app.AMPacket -> AMSenderC;
	
	app.PacketAck -> ActiveMessageC;
	
}
