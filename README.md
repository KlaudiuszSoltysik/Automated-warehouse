# Automated Warehouse
This project simulates an automated warehouse equipped with two cranes and multiple conveyors. The warehouse operations are managed by a virtual SIMATIC S7-1500 PLC. The backend, built with Django Rest Framework, retrieves data from the PLC's data blocks and forwards this information to an API endpoints. A Flutter application consumes this API to display the warehouse status in real-time. Additionally, the mobile app allows users control magazine.

## Simulation - FactoryIO
The warehouse is built in FactoryIO with components such as conveyors, turnable conveyors, sensors, RFID scanners, and cranes.
![image](https://github.com/user-attachments/assets/d13e4e2f-b4e3-4b0b-a297-d436e857a2ff)

## PLC - TIA Portal
The PLC program is written in LAD, SCL, and GRAPH languages. Good programming practices were taken care of. All boxes are sorted by size to maintain an equal number of each size in both storage areas. An RFID scanner reads the RFID tag data of each box. The crane then places the box in the first available slot. Users can order a specific box by its ID or by size, and the program will select the appropriate box for unloading. Program is protected against errors and unexpected behaviour. In service mode all boxes are directed to working magazine.
* SCREEN Z MAINA *

## Backend - Django Rest Framework
The backend forwards the data block information to API endpoints and updates the order area in the data block.

## Mobile application - Flutter
The application displays the status of each storage area and can be used to place orders or to turn on service mode.
* POPRAWIĆ SCREENY *
<p align="center">
  <img src="https://github.com/user-attachments/assets/80d0d8e1-ede6-4194-bc3e-9214dd2c821e" alt="Screenshot 1" width="33%" />
  <img src="https://github.com/user-attachments/assets/ea024967-8000-47b8-b3cd-802ed6ff5d7b" alt="Screenshot 2" width="33%" />
  <img src="https://github.com/user-attachments/assets/a586d55a-b221-4571-8f19-bf5a8d65a239" alt="Screenshot 3" width="33%" />
</p>

## Future Enhancements
- build a website