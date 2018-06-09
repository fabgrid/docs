# Interfacing with the MFRC522

[MFRC522 Data Sheet](http://www.nxp.com/documents/data_sheet/MFRC522.pdf)

## Physical Mod

As it requires less pins on the "host", I want to use UART communication. Therefore, i have to cut a trace according to [these instructions](https://forum.arduino.cc/index.php?topic=442750.0). Afterwards, i can hook up the Rx and Tx pins to a microcontroller and start to fiddle with the MFRC522 command set.

## The Protocol

According to the data sheet, the chip has several registers, which can be read by sending their respective address (byte) to the MFRC522's Rx pin and reading the corresponding data (byte) from its Tx pin. The default baud rate for UART is 9600. Writing works by sending the address byte followed by a data byte.

Let's take a look at the registers…


