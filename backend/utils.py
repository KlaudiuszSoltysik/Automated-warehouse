import snap7
from snap7.util import get_bool, get_int
import json

def read_data():
    plc_ip = '192.168.0.1'
    rack = 0
    slot = 1
    db_number = 40
    magazine2_offset = 324

    client = snap7.client.Client()
    client.connect(plc_ip, rack, slot)

    data = client.db_read(db_number, 0, 648)
    magazine1 = []
    magazine2 = []

    for i in range(54):
        base = 6 * i
        
        magazine1.append({f'shelf{i + 1}': {
            'is_occupied': get_bool(data, base + 0, 0),
            'ID': get_int(data, base + 2),
            'box_size': get_int(data, base + 4)
        }})
        magazine2.append({f'shelf{i + 1}': {
            'is_occupied': get_bool(data, magazine2_offset + base + 0, 0),
            'ID': get_int(data, magazine2_offset + base + 2),
            'box_size': get_int(data, magazine2_offset + base + 4)
        }})

    client.disconnect()

    return json.dumps({'magazine1': magazine1, 'magazine2': magazine2}, indent=2)

def order_box(magazine, id):
    print(f"magazine: {magazine}, id: {id}")
    return "OK"

def order_size(size):
    print(f"size: {size}")
    return "OK"