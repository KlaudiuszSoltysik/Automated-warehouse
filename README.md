# Automated Warehouse
This project simulates an automated warehouse equipped with two cranes and multiple conveyors. The warehouse operations are managed by a virtual SIMATIC S7-1500 PLC. The backend, built with Django, retrieves data from the PLC's data blocks and forwards this information to an API endpoint. A Flutter application consumes this API to display the warehouse status in real-time. Additionally, the mobile app allows users to order a crane to unload a box from the warehouse.

## Simulation - FactoryIO
The warehouse is built in FactoryIO with components such as conveyors, turnable conveyors, sensors, RFID scanners, and cranes.
![image](https://github.com/user-attachments/assets/d13e4e2f-b4e3-4b0b-a297-d436e857a2ff)

## PLC - TIA Portal
The PLC program is neatly written in LAD, SCL, and GRAPH. All boxes are sorted by size to maintain an equal number of each size in both storage areas. An RFID scanner reads the RFID tag data of each box, and this data is stored in data blocks. The crane then places the box in the first available slot. Users can order a specific box by its ID or by size, and the program will select the appropriate box for unloading.

## Backend - Django Rest Framework
The backend forwards the data block information to API endpoints and updates the order area in the data block.

## Mobile application - Flutter
The application displays the status of each storage area and can be used to place orders.
![image](https://github.com/user-attachments/assets/84d6d232-22bf-46a0-bef0-b201beaecbbc)

## Future Enhancements
- Allow locking of one of the storage areas.
- build a website
