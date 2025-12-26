# 🏭 Automated Warehouse

A comprehensive proof-of-concept demonstrating the convergence of **Industrial Automation (OT)** and **Modern Software (IT)**. This project creates a Digital Twin of a logistics center where a virtual PLC controls physical machinery while communicating in real-time with a mobile app via a REST API bridge.

## ⚙️ Architecture & Core Mechanics

The system moves beyond simple simulation by implementing a full data pipeline:

- **🧠 Industrial Brain (PLC):** A virtual **SIMATIC S7-1500** controller runs the logic for cranes, conveyors, and sorters.
- **bridge Middleware (Python):** A **Django Rest Framework** service acts as a gateway, translating raw PLC memory data (Data Blocks) into JSON format.
- **📱 Human-Machine Interface (Mobile):** A **Flutter** app replaces traditional HMI panels, allowing remote monitoring and order placement.

## 🚀 Technical Highlights

### 🤖 PLC Logic (TIA Portal & FactoryIO)
Control software written in **LAD, SCL, and GRAPH**, adhering to industrial programming standards.
- **Smart Sorting:** Dynamic algorithms route boxes based on size and warehouse capacity.
- **RFID Tracking:** Integration with simulated RFID scanners to manage inventory IDs.
- **Safety & Error Handling:** Robust state machine logic prevents collisions and handles unexpected interruptions.

### 🌐 Backend & Connectivity (Python)
- **Data Exposure:** Exposes PLC variables to external systems via REST endpoints.
- **Order Management:** Translates HTTP requests from the mobile app into boolean triggers within the PLC memory.

### 📱 Mobile App (Flutter)
- **Real-Time Visualization:** Displays live occupancy status of storage slots.
- **Remote Control:** Allows users to request specific items (by ID) or general product types, overriding the automatic sorting process.

## 📸 Visualization

### Simulation Environment (FactoryIO)
![image](https://github.com/user-attachments/assets/d13e4e2f-b4e3-4b0b-a297-d436e857a2ff)

### Mobile Interface
<p align="center">
  <img src="https://github.com/user-attachments/assets/80d0d8e1-ede6-4194-bc3e-9214dd2c821e" width="32%" />
  <img src="https://github.com/user-attachments/assets/ea024967-8000-47b8-b3cd-802ed6ff5d7b" width="32%" />
  <img src="https://github.com/user-attachments/assets/a586d55a-b221-4571-8f19-bf5a8d65a239" width="32%" />
</p>
