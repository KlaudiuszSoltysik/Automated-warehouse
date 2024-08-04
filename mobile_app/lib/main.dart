import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magazine Manager',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  Map<String, dynamic> _data = {};
  Magazine magazine1 = Magazine();
  Magazine magazine2 = Magazine();

  @override
  void initState() {
    super.initState();
    startGettingMagazines();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: _data.isEmpty
          ? serverStatusContainer(context)
          : Container(
              color: Colors.grey[800],
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Text(
                      'MAGAZINE 1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 60),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: 54,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () =>
                              showPopup1(context, 1, magazine1.shelves[index]),
                          child: Container(
                            color: magazine1.shelves[index].isOccupied
                                ? Colors.red
                                : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'MAGAZINE 2',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: 54,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () =>
                              showPopup1(context, 2, magazine2.shelves[index]),
                          child: Container(
                            color: magazine2.shelves[index].isOccupied
                                ? Colors.red
                                : Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 60, 10, 100),
                    child: SizedBox(
                      height: screenWidth * 0.2,
                      child: ElevatedButton(
                        onPressed: () {
                          showPopup2(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            'ORDER',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: screenWidth * 0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget serverStatusContainer(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<bool>(
      future: isServerAvailable(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!) {
          return Container(
            color: Colors.grey[800],
            child: const Center(
              child: DotAnimation(),
            ),
          );
        } else {
          return Container(
            color: Colors.grey[800],
            child: Center(
              child: Text(
                'Server available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<bool> isServerAvailable() async {
    final response =
        await http.get(Uri.parse('https://your-backend-server.com/health'));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkServer() async {
    bool available = await isServerAvailable();

    if (available) {
      return true;
    } else {
      return false;
    }
  }

  void startGettingMagazines() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      getMagazines();
    });
  }

  Future<void> getMagazines() async {
    const url = 'http://192.168.33.9:8000/magazines/';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _data = data;
        magazine1.updateFromMap(data['magazine1']);
        magazine2.updateFromMap(data['magazine2']);
      });
    } else {
      _data = {};
    }
  }

  void postBoxOrder(int magazine, int id) async {
    final url = Uri.parse('http://192.168.33.9:8000/order_box/');

    final data = jsonEncode({"magazine": magazine, "id": id});

    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: data,
    );
  }

  void postSizeOrder(int size) async {
    final url = Uri.parse('http://192.168.33.9:8000/order_size/');

    final data = jsonEncode({"size": size});

    await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: data,
    );
  }

  void showPopup1(BuildContext context, int magazine, Shelf shelf) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shelf ${shelf.index}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Occupied:',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${shelf.isOccupied}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Size:',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${shelf.boxSize}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID:',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${shelf.id}',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              shelf.isOccupied
                  ? const SizedBox(
                      height: 20,
                    )
                  : Container(),
              shelf.isOccupied
                  ? ElevatedButton(
                      onPressed: () {
                        postBoxOrder(magazine, shelf.id);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'ORDER',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void showPopup2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String dropdownValue = '-';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['-', 'S', 'M', 'L']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (dropdownValue != '-') {
                        if (dropdownValue == 'S') {
                          postSizeOrder(1);
                        } else if (dropdownValue == 'M') {
                          postSizeOrder(2);
                        } else if (dropdownValue == 'L') {
                          postSizeOrder(3);
                        }
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ORDER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DotAnimation extends StatefulWidget {
  const DotAnimation({super.key});

  @override
  DotAnimationState createState() => DotAnimationState();
}

class DotAnimationState extends State<DotAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animation = IntTween(begin: 0, end: 3).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        int dots = _animation.value;
        String dotString = '.' * dots;
        String spaceString = ' ' * (3 - dots);
        return Text(
          'Fetching data$dotString$spaceString',
          style: TextStyle(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.08,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Shelf {
  bool isOccupied;
  int id;
  int boxSize;
  int index;

  Shelf({
    required this.isOccupied,
    required this.id,
    required this.boxSize,
    required this.index,
  });
}

class Magazine {
  List<Shelf> shelves;
  List<int> j = [
    53,
    44,
    35,
    26,
    17,
    8,
    52,
    43,
    34,
    25,
    16,
    7,
    51,
    42,
    33,
    24,
    15,
    6,
    50,
    41,
    32,
    23,
    14,
    5,
    49,
    40,
    31,
    22,
    13,
    4,
    48,
    39,
    30,
    21,
    12,
    3,
    47,
    38,
    29,
    20,
    11,
    2,
    46,
    37,
    28,
    19,
    10,
    1,
    45,
    36,
    27,
    18,
    9,
    0
  ];

  Magazine()
      : shelves = List.generate(
            54,
            (index) => Shelf(
                  isOccupied: false,
                  id: 0,
                  boxSize: 0,
                  index: 0,
                ));

  void updateFromMap(List<dynamic> data) {
    for (int i = 0; i < 54; i++) {
      Map<String, dynamic> map = data[i]['shelf${i + 1}'];
      shelves[j[i]].isOccupied = map['is_occupied'];
      shelves[j[i]].id = map['ID'];
      shelves[j[i]].boxSize = map['box_size'];
      shelves[j[i]].index = i + 1;
    }
  }
}