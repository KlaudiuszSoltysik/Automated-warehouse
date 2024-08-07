import snap7
from snap7.util import get_bool, get_int, set_int
import json

plc_ip = '192.168.0.1'
rack = 0
slot = 1
db_number = 40

client = snap7.client.Client()

lock = False

def read_data():
    global lock
    if not lock:
        magazine2_offset = 324

        client.connect(plc_ip, rack, slot)

        data = client.db_read(db_number, 0, 648)
        magazine1 = []
        magazine2 = []

        for i in range(54):
            base = 6 * i
            
            magazine1.append({f'shelf{i + 1}': {
                'is_occupied': get_bool(data, base, 0),
                'ID': get_int(data, base + 2),
                'box_size': get_int(data, base + 4)
            }})
            magazine2.append({f'shelf{i + 1}': {
                'is_occupied': get_bool(data, magazine2_offset + base + 0, 0),
                'ID': get_int(data, magazine2_offset + base + 2),
                'box_size': get_int(data, magazine2_offset + base + 4)
            }})

        client.disconnect()

        return json.dumps({'magazine1': magazine1, 'magazine2': magazine2})
    return json.dumps({'magazine1': [], 'magazine2': []})

def order_box(id, magazine):
    global lock
    lock = True

    client.connect(plc_ip, rack, slot)

    data = client.db_read(db_number, 668, 36)

    for i in range(6):
        base = 6 * i

        ID = get_int(data, base)
        box_size = get_int(data, base + 4)

        if id == ID:
            print(id)
            print(ID)
            break

        if ID == 0 and box_size == 0:
            set_int(data, base, id)
            set_int(data, base + 2, magazine)
            client.db_write(db_number, 668, data)

            client.disconnect()
            lock = False
            return True
        
    client.disconnect()
    lock = False
    return False 

def order_size(size):
    global lock
    lock = True
    client.connect(plc_ip, rack, slot)

    data = client.db_read(db_number, 668, 36)

    for i in range(5):
        base = 6 * i

        ID = get_int(data, base)
        box_size = get_int(data, base + 4)

        if ID == 0 and box_size == 0:
            set_int(data, base + 4, size)
            client.db_write(db_number, 668, data)

            client.disconnect()
            lock = False
            return True
        
    client.disconnect()
    lock = False
    return False