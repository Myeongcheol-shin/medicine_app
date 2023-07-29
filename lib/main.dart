import 'dart:async';
import 'package:flutter/material.dart';
import 'package:medicine_app/model/medicine_model.dart';
import 'package:medicine_app/service/api_service.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = '효능';
  String? infoData = "";
  String name = "Medicine Info Search";
  Color _randomColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];
  bool firstInit = false;
  List<Items> itemsList = [];
  int selectedItem = -1;
  StreamController ctrl = StreamController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(() => {
          if (!_focusNode.hasFocus) {resetSearchState()}
        });
    medicines = ApiService.getMedicine("");
  }

  setIfonData() {
    final tmp = itemsList[selectedItem];
    setState(() {
      switch (status) {
        case '효능':
          {
            infoData = tmp.efcyQesitm;
            break;
          }
        case '사용법':
          {
            infoData = tmp.useMethodQesitm;
            break;
          }
        case '주의사항I':
          {
            infoData = tmp.atpnWarnQesitm;
            break;
          }
        case '주의사항II':
          {
            infoData = tmp.atpnQesitm;
            break;
          }
        case '보관법':
          {
            infoData = tmp.depositMethodQesitm;
            break;
          }
        case '상호작용':
          {
            infoData = tmp.intrcQesitm;
            break;
          }
        case '부작용':
          {
            infoData = tmp.seQesitm;
            break;
          }
      }
    });
  }

  resetSearchState() {
    setState(() {
      isSearching = false;
    });
  }

  Future<void> _onSearchChanged() async {
    if (_searchController.text == "") {
      setState(() {
        firstInit = false;
      });
      return;
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        firstInit = true;
        isSearching = true;
        medicines = ApiService.getMedicine(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  late Future<List<Items>> medicines;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: isSearching
                  ? TextField(
                      autofocus: false,
                      focusNode: _focusNode,
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        // Perform search functionality here
                      },
                    )
                  : Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                    ),
              actions: [
                IconButton(
                    icon: isSearching
                        ? const Icon(Icons.close)
                        : const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                        if (isSearching) {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            FocusScope.of(context).requestFocus(_focusNode);
                          });
                        } else {
                          FocusScope.of(context).unfocus();
                          resetSearchState();
                        }
                      });
                    })
              ],
            ),
            body: Stack(
              children: [
                if (selectedItem != -1)
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      resetSearchState();
                    },
                    child: AbsorbPointer(
                        absorbing: isSearching,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (var item in [
                                  '효능',
                                  '사용법',
                                  '주의사항I',
                                  '주의사항II'
                                ])
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        status = item;
                                      });
                                      setIfonData();
                                    },
                                    child: infoWidget(
                                        name: item, randomColor: _randomColor),
                                  )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                for (var item in ['보관법', '부작용', '상호작용'])
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        status = item;
                                      });
                                      setIfonData();
                                    },
                                    child: infoWidget(
                                        name: item, randomColor: _randomColor),
                                  )
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(50),
                                child: AspectRatio(
                                  aspectRatio: 1 / 2,
                                  child: medicineWidget(_randomColor),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                if (isSearching)
                  FutureBuilder(
                    future: medicines,
                    builder: (context, snapshot) {
                      if (snapshot.hasData == false) {
                        return const CircularProgressIndicator();
                      }
                      if (!firstInit) return const SizedBox();
                      if (snapshot.data!.isEmpty) {
                        return const Text("");
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => Container(
                              color: Colors.white,
                              child: ListTile(
                                  title: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = '효능';
                                    infoData = snapshot.data![index].efcyQesitm;
                                    name = snapshot.data![index].itemName;
                                    _randomColor = Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)];
                                    itemsList = snapshot.data!;
                                    selectedItem = index;
                                    isSearching = !isSearching;
                                    if (isSearching) {
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode);
                                      });
                                    } else {
                                      FocusScope.of(context).unfocus();
                                      resetSearchState();
                                    }
                                  });
                                },
                                child: Row(children: [
                                  const Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(Icons.medication_outlined),
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data![index].itemName,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                              ))));
                    },
                  ),
              ],
            )));
  }

  Column medicineWidget(Color color) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2.0,
                      blurRadius: 5.0,
                      offset: const Offset(2, 0))
                ],
                gradient: LinearGradient(colors: [
                  color,
                  color.withOpacity(0.8),
                  color.withOpacity(0.6),
                  color.withOpacity(0.4),
                ]), // 파란색 표시 색상
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(130),
                  topRight: Radius.circular(130),
                )),
            child: Center(
                child: Text(
              status,
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            )),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
                left: 10, right: 10, top: 10, bottom: 100),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2.0,
                      blurRadius: 5.0,
                      offset: const Offset(2, 3))
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(130),
                  bottomRight: Radius.circular(130),
                )),
            child: SingleChildScrollView(
                child: Center(child: Text(infoData ?? "정보가 없습니다"))),
          ),
        ),
      ],
    );
  }
}

class infoWidget extends StatelessWidget {
  const infoWidget({
    super.key,
    required String name,
    required Color randomColor,
  })  : _randomColor = randomColor,
        _name = name;

  final String _name;
  final Color _randomColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: _randomColor),
      child: Text(
        _name,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}
