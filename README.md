TransmitTimer
=============
This applicaiton periodically toggles between sending even and odd binary digits to two nodes and counts the number of acknowledgements received from the receving nodes.

Four nodes may be used to verify the working of this application. This is a transmitting applciation which may be installed on one node while atleast one other node may be installed with the 'MessageSniffer' application and 'MessageReceiver' may be installed on the remaining ones. The receiving nodes are to be named node  3 and node 4. The node installed with 'MessageSniffer' is to be connected to the computer so that it can sense the packets being trasnmitted and send network data to the computer serially.

The expected result is the nodes 3 and 4 receive a count periodically toggled between even and odd binary digits which is displayed on their respective leds. The total number of lost packets is kept in each transmitting node and sent in the packet along with the binary count which can be found out the 'Sniffer node' connected serially to the computer which also gives the binary count being transmitted by running the 'TestSerial' application in the terminal window.

This applicaiton changes the count every 2 secinds irrespective of whether the transmission was successfull or not. When a transmission is unsuccessfull, it tries to retransmit the packet a maximum of 8 times before stopping the retransmissions. 

This application is different from 'TimerAcked' and 'ACKedTrasnmit' by the fact that the count changes every 2 seconds regardless of the success or failure of the previous transmission.




08/14/2014 - First upload of the application which includes the header, module and configuration files.
