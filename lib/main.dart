import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(AgriculturalAutomationApp());
}

class AgriculturalAutomationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agricultural Automation System',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Perform authentication logic here
    // For simplicity, assume authentication is successful
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('المزرعة السعيدة'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: ClockAndDateWidget(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SensorDataWidget(
                  value: '25°C',
                  label: 'Temperature',
                ),
                SensorDataWidget(
                  value: '60%',
                  label: 'Humidity',
                ),
                SensorDataWidget(
                  value: '10 m/s',
                  label: 'Wind Speed',
                ),
              ],
            ),
            SizedBox(height: 40),
            IrrigationButton(),
            SizedBox(height: 20),
            CropSelectionButton(),
          ],
        ),
      ),
    );
  }
}

class CropSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CropSelectionPage()),
        );
      },
      child: Text('Select Crops'),
    );
  }
}

class ClockAndDateWidget extends StatefulWidget {
  @override
  _ClockAndDateWidgetState createState() => _ClockAndDateWidgetState();
}

class _ClockAndDateWidgetState extends State<ClockAndDateWidget> {
  String _currentTime = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _updateDate();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateDate();
    });
  }

  void _updateTime() {
    setState(() {
      _currentTime =
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    });
  }

  void _updateDate() {
    setState(() {
      _currentDate =
          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '$_currentDate $_currentTime',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

class SensorDataWidget extends StatelessWidget {
  final String value;
  final String label;

  const SensorDataWidget({
    Key? key, // Change Key key to Key? key
    required this.value, // Change @required to required
    required this.label, // Change @required to required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class IrrigationButton extends StatefulWidget {
  @override
  _IrrigationButtonState createState() => _IrrigationButtonState();
}

class _IrrigationButtonState extends State<IrrigationButton> {
  bool _isLoading = false;

  void _startIrrigation() {
    setState(() {
      _isLoading = true;
    });
    // Simulate irrigation process
    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        // Show a snackbar indicating successful irrigation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Irrigation Successful'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _startIrrigation,
      child:
          _isLoading ? CircularProgressIndicator() : Text('Start Irrigation'),
    );
  }
}

class CropSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Selection'),
      ),
      body: ListView(
        children: [
          CropItem(name: 'Mango'),
          CropItem(name: 'Apple'),
          CropItem(name: 'Banana'),
          CropItem(name: 'Grapes'),
          CropItem(name: 'Orange'),
        ],
      ),
    );
  }
}

class CropItem extends StatelessWidget {
  final String name;

  const CropItem({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      onTap: () {
        // Show quantity popup when crop item is tapped
        showDialog(
          context: context,
          builder: (context) => QuantityPopup(cropName: name),
        );
      },
    );
  }
}

class QuantityPopup extends StatelessWidget {
  final String cropName;

  const QuantityPopup({Key? key, required this.cropName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Enter Quantity for $cropName'),
      content: TextField(
        decoration: InputDecoration(labelText: 'Quantity'),
        keyboardType: TextInputType.number,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement logic to confirm the task
            // For demonstration, we'll just show a message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task confirmed for $cropName')),
            );
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
