import snap7
from snap7.util import get_bool, get_int, set_bool, set_int
import json
import atexit

db_number = 40
plc_ip = '192.168.0.1'
rack = 0
slot = 1

client = snap7.client.Client()
client.connect(plc_ip, rack, slot)

def close_plc_connection():
    if client.get_connected():
        client.disconnect()
        client.destroy()

atexit.register(close_plc_connection)

def read_data():
    magazine2_offset = 324

    magazine1 = []
    magazine2 = []

    data = client.db_read(db_number, 0, 705)

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

    magazine1_lock = get_bool(data, 704, 5)
    magazine2_lock = get_bool(data, 704, 6)

    return json.dumps({'magazine1': magazine1, 'magazine2': magazine2, 'magazine1_lock': magazine1_lock, 'magazine2_lock': magazine2_lock})

def order_box(id, magazine):
    data = client.db_read(db_number, 668, 36)

    for i in range(6):
        base = 6 * i

        ID = get_int(data, base)
        box_size = get_int(data, base + 4)

        if id == ID:
            break

        if ID == 0 and box_size == 0:
            set_int(data, base, id)
            set_int(data, base + 2, magazine)
            client.db_write(db_number, 668, data)
            return True

    return False 

def order_size(size):
    data = client.db_read(db_number, 668, 36)

    for i in range(5):
        base = 6 * i

        ID = get_int(data, base)
        box_size = get_int(data, base + 4)

        if ID == 0 and box_size == 0:
            set_int(data, base + 4, size)
            client.db_write(db_number, 668, data)

            return True
        
    return False

def update_magazine_locks(magazine1_lock, magazine2_lock):
    data = client.db_read(db_number, 704, 1)

    set_bool(data, 0, 5, magazine1_lock)
    set_bool(data, 0, 6, magazine2_lock)

    client.db_write(db_number, 704, data)

    return True