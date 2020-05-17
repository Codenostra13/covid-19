import 'dart:core';
import 'dart:async';

import 'package:covid_19/questions.dart';
import 'package:covid_19/results.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 express test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Covid-19 express test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  ProgressDialog pr;

  double _counter = 0.0;


  bool _isProgress = false;
  bool _isInit = false;
  bool _isDone = false;

  int _currentQuestion = 1;
  int _maxQuestionId = 11;

  Map<int, int> _answers = {};

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  TextStyle style20 = new TextStyle(
    inherit: true,
    fontSize: 20.0,
  );

  TextStyle style38 = new TextStyle(
    inherit: true,
    fontSize: 38.0,
  );

  void initState() {
    super.initState();

     _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    //..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {

        if (_isDone) {
          return;
        }

        if (_isInit) {
          setState(() {
            _isInit = false;
          });
        }

        var nextQuestion = QUESTIONS.firstWhere((question) {
          if (_currentQuestion <  question['id']) {
            bool conditionMatch = true;
            for (var condition in question['conditions']) {
              if (_answers[condition['question']] != condition['option']) {
                conditionMatch = false;
                break;
              }
            }

            return conditionMatch;
          }
          return false;
        });
        setState(() {
          if (nextQuestion == null) {
          } else {
            _currentQuestion = nextQuestion['id'];

            setState(() {
              _isInit = true;
            });
            _controller.reverse();
            //_controller.forward();
          }
        });

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _transition(questionId, option) {
    if (_isProgress) {
      return;
    }

    setState(() {
      _isProgress = true;
    });

    setState(() {
      _counter += option["point"];
      _answers[questionId] = option["value"];
    });

    new Timer(Duration(milliseconds: 500), () {
      setState(() {
        _isProgress = false;
      });
      if (_maxQuestionId <= _currentQuestion) {
        setState(() {
          _isDone = true;
        });
      } else {
        _controller.forward();
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context, isDismissible: false);
    pr.style(message: 'Your geo location is sending to ...');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(
          widget.title + "\n choose  your destiny",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        flexibleSpace: Image(
          image: AssetImage('lib/assets/background.png'),
          fit: BoxFit.cover,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              child: Icon(Icons.gps_not_fixed),
              onPressed: (){
                // see you later..
                if (_isDone) {
                  pr.show();
                }
              },
            ),
          )
        ],
      ),
      body: _isDone ? _buildResultBody(): _buildQuizBody(),
    );
  }

  Widget _buildResultBody(){
    String resultPrediction = "Your should.......";

    var resultItem = RESULTS.firstWhere((r) {
      return (_counter >= r["start"] && _counter <= r["stop"]);
    }, orElse: () {
      return null;
    });

      
    var resultColor = Colors.white;

    if (resultItem != null) {
      resultPrediction = resultItem["title"];
      resultColor = resultItem["color"];
    }


    return Column(children: <Widget>[
      _points(),
      Expanded(
        child: Container(
          child: Center(
            child: SingleChildScrollView( 
              child: Container(
                constraints: BoxConstraints( maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: RaisedButton(
                          child: Text("Pass test again ",  style: style38),
                          onPressed: () {
                            setState(() {
                              _counter = 0.0;
                              _answers = {};
                              _currentQuestion = 1;
                              _isDone = false;
                            });
                          }),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 20.0),
                      child: Container(
                        color: resultColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                          child: Text(
                            resultPrediction,
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.blueGrey,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Disclammer:"),
                                  Text(
                                      "This tool does not provide medical advice It is intended for informational purposes only. It is not a substitute for professional medical advice, diagnosis or treatment. Never ignore professional medical advice in seeking treatment because of something you have read on the WebMD Site. If you think you may have a medical emergency, immediately call your doctor or dial Emergency center.")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                      child: Text(
                        "If you think that you have symptoms of COVID-19, here’s what to do:",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                      child: Text(_getInfoText()),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
                      child: RichText(
                        text: TextSpan(
                          text: "https://www.who.int/health-topics/coronavirus",
                          style: new TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () async {
                              const url =
                                  'https://www.who.int/health-topics/coronavirus';
                              if (await canLaunch(url)) {
                                await launch(url);
                              }
                            },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildQuizBody(){
    var  currentQuestion = _getCurrentQuestion();

    if (currentQuestion == null) {
      return SizedBox();
    }
    var questionTitle = currentQuestion['question'];
    
    

    return Column(children: <Widget>[
      _points(),
      Expanded(child: Center(child:SlideTransition(
        position: _offsetAnimation,
        child: Column(children: <Widget>[

          Container(
            constraints: BoxConstraints(maxWidth:600),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
              child: Text(questionTitle),
            ),
          ),
          Container(child: Column(children: _buildOptions(currentQuestion),))
        ],),
        

      )),)
    ],);
  }

  _getInfoText() {
    String text =
        'Monitor your symptoms. Not everyone with COVID-19 requires hospitalization. However,';
    text +=
        'keeping track of your symptoms is important since they may worsen in the second week of ';
    text += 'illness.' + "\n";
    text +=
        'Contact your doctor. Even if your symptoms are mild, it’s still a good idea to call your';
    text +=
        ' doctor to let them know about your symptoms and any potential exposure risks.';
    text +=
        'Get tested. Your doctor can work with local health authorities and ';
    text +=
        'the CDC to evaluate your symptoms and risk of exposure to determine if you need to be tested for COVID-19.';
    text +=
        'Stay isolated. Plan to isolate yourself at home until your infection ';
    text +=
        'has cleared up. Try to stay separated from other people in your home, using a separate bedroom and bathroom if possible.';
    text +=
        'Seek care. If your symptoms worsen, seek prompt medical care. Be sure to call ';
    text +=
        'ahead before you arrive at a clinic or hospital. Wear a face mask, if available.';

    text += 'What can you do to protect yourself from the coronavirus?' + "\n";
    text +=
        'Follow the tips below to help protect yourself and others from a SARS-CoV-2 infection:' +
            "\n" +
            "\n";

    text +=
        'Wash your hands. Be sure to wash your hands frequently with soap and warm water. If this isn’t available, use an alcohol-based hand sanitizer.' +
            "\n";
    text +=
        'Avoid touching your face. Touching your face or mouth if you haven’t washed your hands can transfer the virus to these areas and potentially make you sick.' +
            "\n";
    text +=
        'Maintain distance. Avoid close contact with people who are ill. If you’re around someone that’s coughing or sneezing, try to stay at least 3 feetTrusted Source away.' +
            "\n";
    text +=
        'Don’t share personal items. Sharing items such as eating utensils and drinking glasses can potentially spread the virus.' +
            "\n";
    text +=
        'Cover your mouth when you cough or sneeze. Try to cough or sneeze into the crook of your elbow or into a tissue. Be sure to promptly dispose of any used tissues.' +
            "\n";
    text +=
        'Stay home if you’re sick. If you’re already ill, plan to stay at home until you recover.' +
            "\n";
    text +=
        'Clean surfaces. Use household cleaning sprays or wipes to clean high-touch surfaces, such as doorknobs, keyboards, and countertops.' +
            "\n";

    text +=
        'Keep yourself informed. The CDC continuously updates informationTrusted Source as it becomes available and the WHO publishes daily situation reportsTrusted Source.';

    return text;
  }

  Widget _points() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Your points :   $_counter",
        style: TextStyle(fontSize: 20),
      ),
    );
  }


  _getCurrentQuestion(){
    return QUESTIONS.firstWhere((question) =>  question['id'] == _currentQuestion);
  }

  List<Widget> _buildOptions(currentQuestion){
    List questionOptions = currentQuestion["options"] as List;
    List<Widget> result = [];

    for (var i = 0; i < questionOptions.length; i++) {
      RaisedButton btn = RaisedButton(
          child: Text(questionOptions[i]["title"],  style: style20),
          color: _answers[_currentQuestion] == null ||
                  _answers[_currentQuestion] != questionOptions[i]['value']
              ? Colors.white
              : questionOptions[i]["color"],
          onPressed: () {
            _transition(_currentQuestion, questionOptions[i]);
          });

      result.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: btn,
      ));
    }

    return result;
  }
}
