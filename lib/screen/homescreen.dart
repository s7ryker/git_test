import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_repos/main.dart';
import 'package:github_repos/models/repo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mycontroller = TextEditingController();
  bool hasLoaded = false;
  var futureRepos;
  List<Repo> repos = [];
  Future<All> resopnseDecode(String uname) async {
    final response = await fetchRepos(uname);
    return All.fromJson(json.decode(response.body));
  }

  Future<void> initFi() async {
    final futureRepo = await fetchRepos('');
    if (futureRepo.statusCode == 200) {
      hasLoaded = true;
      futureRepos = All.fromJson(json.decode(futureRepo.body));
    } else {
      hasLoaded = false;
    }
  }

  void initState() {
    super.initState();
    initFi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff201E1E),
      appBar: AppBar(
        backgroundColor: Color(0xff201E1E),
        title: Center(child: Text('GitHub Repos')),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: FutureBuilder<All>(
            future: futureRepos,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Repo> repos = [];
                for (int i = 0; i < snapshot.data!.repos.length; i++) {
                  repos.add(
                    Repo(
                      name: snapshot.data!.repos[i].name,
                      htmlUrl: snapshot.data!.repos[i].htmlUrl,
                      starCount: snapshot.data!.repos[i].starCount,
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: 110,
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: repos
                                  .map(
                                    (r) => Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6.0,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  r.name,
                                                  style:
                                                      TextStyle(fontSize: 18.0),
                                                ),
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(r.htmlUrl),
                                                    ),
                                                    SizedBox(
                                                      width: 85,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Icon(
                                                        Icons.star,
                                                        color:
                                                            Color(0xffFFE600),
                                                      ),
                                                    ),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(r.starCount
                                                            .toString())),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Color(0xff201E1E),
                        height: MediaQuery.of(context).size.height / 7.7,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 12,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  // vertical: 8.0,
                                ),
                                child: TextFormField(
                                  controller: mycontroller,
                                  decoration: InputDecoration(
                                    hintText: "Enter your GitHub username",
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    suffix: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        alignment: Alignment.center,
                                        primary: Color(0xff201E1E),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          futureRepos =
                                              resopnseDecode(mycontroller.text);
                                        });
                                      },
                                      child: Text("Search"),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Text(
                                  "Repositories",
                                  style: TextStyle(
                                    color: Color(0xff7D7979),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: mycontroller,
                        decoration: InputDecoration(
                          hintText: "Enter your GitHub username",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          suffix: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              primary: Color(0xff201E1E),
                            ),
                            onPressed: () {
                              setState(() {
                                futureRepos = resopnseDecode(mycontroller.text);
                              });
                            },
                            child: Text("Search"),
                          ),
                        ),
                      ),
                      Text('No Data Found')
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    TextFormField(
                      controller: mycontroller,
                      decoration: InputDecoration(
                        hintText: "Enter your GitHub username",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: InputBorder.none,
                        suffix: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.center,
                            primary: Color(0xff201E1E),
                          ),
                          onPressed: () {
                            setState(() {
                              futureRepos = resopnseDecode(mycontroller.text);
                            });
                          },
                          child: Text("Search"),
                        ),
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
