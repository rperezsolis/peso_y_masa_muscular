import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:peso_y_masa_muscular/bloc/indicators_bloc.dart';
import 'package:peso_y_masa_muscular/model/indicator.dart';
import 'package:peso_y_masa_muscular/ui/indicator_form.dart';
import 'package:peso_y_masa_muscular/ui/indicator_graph.dart';
import 'package:peso_y_masa_muscular/ui/theme_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Tab> _myTabs = <Tab>[
    Tab(text: 'Peso'),
    Tab(text: 'IMC'),
    Tab(text: '% Músculo'),
    Tab(text: '% Grasa'),
  ];
  List<Indicator> _indicators = [];
  double _height;
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    bloc.getIndicators();
    _checkUserDefaultHeight();
  }

  void _checkUserDefaultHeight() async {
    _prefs = await SharedPreferences.getInstance();
    _height = _prefs.getDouble('height') ?? 0;
  }

  void _goToForm() async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => IndicatorForm(context: context, height: _height)));
    await _prefs.setDouble('height', double.parse('$result'));
    _height = double.parse('$result');
    setState(() {});
  }

  void _changeColor() async {
    ThemeColor.changeColor(_prefs, context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allIndicators,
      builder: (context, AsyncSnapshot<List<Indicator>> snapshot) {
        return DefaultTabController(
          length: _myTabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Mis indicadores corporales'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: () {
                    _changeColor();
                  },
                ),
              ],
              bottom: TabBar(
                indicatorColor: Colors.white,
                isScrollable: true,
                tabs: _myTabs,
              ),
            ),
            body: TabBarView(
              children: _myTabs.map((Tab tab) {
                final int indicatorIndex = _myTabs.indexOf(tab);
                if(snapshot.hasData && snapshot.data.length>0) {
                  _indicators.clear();
                  _indicators.addAll(snapshot.data);
                  return IndicatorGraph(
                    seriesList: IndicatorGraph.createSeries(
                        _indicators, indicatorIndex
                    ),
                  );
                } else if(snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }  else {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text('Sin registro de mediciones', style: TextStyle(fontSize: 20, color: Colors.blueGrey),),
                  ));
                }
              }).toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _goToForm();
              },
              child: Icon(Icons.add),
            ),
          ),
        );
      }
    );
  }
}