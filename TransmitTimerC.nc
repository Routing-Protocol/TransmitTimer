#include <Timer.h>
#include "TransmitTimer.h"


module TransmitTimerC{
	
	uses interface Boot;
	
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	
	uses interface SplitControl as AMControl;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	
	uses interface PacketAcknowledgements as PacketAck;

}

implementation{
	
	uint16_t counter;
	uint16_t LostPackets;
	uint16_t retransmissions = 0;
	uint8_t retx;
		
	message_t pkt;
	
	bool RADIO = FALSE;
	bool BUSY = FALSE;
	bool ACKed = TRUE;
	
	uint8_t node1 = 0x03;
	uint8_t node2 = 0x04;
	uint8_t node3 = 0x99;
	
	uint8_t node0 = 0x05;
	
	event void Boot.booted()
	{
		call Timer0.startPeriodic(TIMER_PERIODIC_MILLI_0);
		
		call AMControl.start();
	}
	
	event void AMControl.startDone(error_t err)
	{
		if (err == SUCCESS)
		{
			RADIO = TRUE;
			
			call Timer1.startPeriodic(TIMER_PERIODIC_MILLI_1);
		}
		
		else
		{
			call AMControl.start();
		}
	}
	
	event void AMControl.stopDone(error_t err)
	{}
	
	event void Timer1.fired()
	{
		node3 = node2;
		node2 = node1;
		node1 = node3;
	}
	
	task void SendMsg()
	{
		TransmitTimerMsg* TTpkt = (TransmitTimerMsg*)(call Packet.getPayload(&pkt, sizeof(TransmitTimerMsg)));
		if (TTpkt == NULL)
		{
			return;
		}
		
		TTpkt->nodeid = TOS_NODE_ID;
		TTpkt->counter = counter;
		TTpkt->lostpackets = LostPackets;
		
		if (TTpkt->counter%0x02 == 0)
		{
			call PacketAck.requestAck(&pkt);
			if (call AMSend.send(node0, &pkt, sizeof(TransmitTimerMsg)) == SUCCESS)
			{
				BUSY = TRUE;
			}			
		}
		
		else
		{
			call PacketAck.requestAck(&pkt);
			if (call AMSend.send(node0, &pkt, sizeof(TransmitTimerMsg)) == SUCCESS)
			{
				BUSY = TRUE;
			}		
		}
	}
	
	event void Timer0.fired()
	{
		if (RADIO == TRUE)
		{
			if (ACKed == TRUE)
			{
				counter++;
			}
			
			if (!BUSY)
			{
				post SendMsg();
			}
		}
		
		else
		{
			call AMControl.start();
		}
	}
	
	event void AMSend.sendDone(message_t* msg, error_t err)
	{
		if (&pkt == msg)
		{
			BUSY = FALSE;
			dbg("TransmitTimerC", "Message was sent @ %s, \n", sim_time_string());
		}
		
		if (call PacketAck.wasAcked(msg))
		{
			retransmissions = retx;
			retx = 0;
			ACKed = TRUE;
		}
		
		else
		{
			retx++;
			LostPackets++;
			ACKed = FALSE;
			if (retx < 8)
			{
				post SendMsg();
			}
		}
	}
}
