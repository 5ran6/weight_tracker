import 'package:weight_tracker/imports/imports.dart';

class Dashboard extends StatefulWidget {
  late final user;
  static String id = 'home';

  Dashboard(user) {
    this.user = user;
  }

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  HomeBloc? homeBloc;
  final GlobalKey<ScaffoldState> globalkey = GlobalKey();
  Api _api = Api();
  DateTime dateTime = DateTime.now();
  int? currentMonth;

  Stream<QuerySnapshot>? weightsData;
  String? weight;
  int? currentDay;
  bool isUpdating = false;
  String? newWeight;
  Timer? _timer;

  @override
  void initState() {
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc!.add(FetchWeights());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is LoadingState) {
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error!),
          ));
        } else if (state is InfoMessage) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message!),
          ));
        } else if (state is WeightsFetched) {
          weightsData = state.data;
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: globalkey,
          backgroundColor: AppTheme.kPrimaryColor,
          appBar: AppBar(
            title: Center(child: Text("Weight Tracker")),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () async {
                  await _api.signOut().then((value) {
                    print(value.toString());
                    if (value != "error"){
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => Auth(),
                        ),
                      );
                    }else{
                      //something went wrong
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        text: "Sign Out unsuccessful! Try again later.",
                      );
                    }
                  });
                },
              ),
            ],
            leading: IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                /** Do something */
              },
            ),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: deviceHeight(context) * 0.05,
              ),
              Container(
                height: 50,
                width: deviceWidth(context) * 0.8,
                margin: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.05),
                child: TextFormField(
                    onChanged: (var value) {
                      weight = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppTheme.kBlackColor,
                        ),
                        fillColor: AppTheme.kWhiteColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Enter weight in kg",
                        hintStyle: AppTheme.blackBold,
                        suffixIcon: state is LoadingState
                            ? IconButton(
                                icon: Icon(
                                  Icons.more_horiz_outlined,
                                  color: AppTheme.kBlackColor,
                                ),
                                onPressed: () {},
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: AppTheme.kBlackColor,
                                ),
                                onPressed: () {
                                  homeBloc!.add(AddWeight(
                                      weight: weight,
                                      time: DateTime.now().toString()));
                                  setState(() {
                                    weight = null;
                                  });
                                },
                              ))),
              ),
              SizedBox(
                height: 8.0,
              ),
              weights(),
            ],
          ),
        );
      },
    );
  }

  Widget weights() {
    return StreamBuilder<QuerySnapshot>(
        stream: weightsData,
        builder: (context, snapshot) {
          var asyncdata = snapshot.data;

          return Container(
            height: deviceHeight(context) * 0.8,
            width: deviceWidth(context),
            child: ListView.builder(
                physics: ScrollPhysics(),
                itemCount: asyncdata != null
                    ? asyncdata.docs != null
                        ? asyncdata.docs.length
                        : 0
                    : 0,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 50,
                      width: deviceWidth(context) * 0.8,
                      margin: EdgeInsets.symmetric(
                          horizontal: deviceWidth(context) * 0.05),
                      child: TextFormField(
                          onChanged: (var value) {
                            newWeight = value;
                          },
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: AppTheme.kBlackColor,
                                ),
                                onPressed: () {
                                  homeBloc!.add(UpdateWeight(
                                      weight: newWeight,
                                      time: DateTime.now().toString(),
                                      id: snapshot.data?.docs[index]['id']));
                                },
                              ),
                              fillColor: AppTheme.kWhiteColor,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintText: snapshot.data?.docs[index]['weight'],
                              hintStyle: AppTheme.blackBold,
                              suffixText: snapshot.data?.docs[index]['time'],
                              suffixStyle: AppTheme.blackBold,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: AppTheme.kBlackColor,
                                ),
                                onPressed: () {
                                  homeBloc!.add(DeleteWeight(
                                      id: snapshot.data?.docs[index]['id']));
                                },
                              ))),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          );
        });
  }
}
