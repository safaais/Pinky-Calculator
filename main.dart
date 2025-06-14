import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
      ),
      home: const Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '0';
  String _currentNumber = '';
  String _operation = '';
  double _num1 = 0;
  bool _newNumber = true;
  bool _showScientific = false;
  bool _isRadianMode = true;


  //Helper function to perform calculations
  num _calculate(double num1, double num2, String operation) {
    switch (operation) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '×':
        return num1 * num2;
      case '÷':
        return num1 / num2;
      case '^':
        return math.pow(num1, num2);
      default:
        return 0; // Handle unexpected operations
    }
  }

  //Helper function for trigonometric and other functions
  String _performFunction(String function, double number) {
    double radNumber = _isRadianMode ? number : number * math.pi / 180;
    switch (function) {
      case 'sin':
        return math.sin(radNumber).toString();
      case 'cos':
        return math.cos(radNumber).toString();
      case 'tan':
        return math.tan(radNumber).toString();
      case '√':
        return math.sqrt(number).toString();
      case 'log':
        return (math.log(number) / math.ln10).toString();
      case 'ln':
        return math.log(number).toString();
      default:
        return ''; //Handle unexpected functions
    }
  }


  void _buttonPressed(String buttonText) {
    setState(() {
      switch (buttonText) {
        case 'C':
          _output = '0';
          _currentNumber = '';
          _operation = '';
          _num1 = 0;
          _newNumber = true;
          break;
        case '.':
          if (!_currentNumber.contains('.')) {
            _currentNumber = _currentNumber.isEmpty ? '0.' : _currentNumber + '.';
            _output = _currentNumber;
            _newNumber = false;
          }
          break;
        case '+':
        case '-':
        case '×':
        case '÷':
        case '^':
          if (_currentNumber.isNotEmpty) {
            _num1 = double.parse(_currentNumber);
            _operation = buttonText;
            _newNumber = true;
          }
          break;
        case '=':
          if (_operation.isNotEmpty && _currentNumber.isNotEmpty) {
            _output = _calculate(_num1, double.parse(_currentNumber), _operation).toString();
            _currentNumber = _output;
            _operation = '';
            _newNumber = true;
          }
          break;
        case '±':
          if (_currentNumber.isNotEmpty) {
            _currentNumber = _currentNumber.startsWith('-') ? _currentNumber.substring(1) : '-$_currentNumber';
            _output = _currentNumber;
          }
          break;
        case 'sin':
        case 'cos':
        case 'tan':
        case '√':
        case 'log':
        case 'ln':
          if (_currentNumber.isNotEmpty) {
            _output = _performFunction(buttonText, double.parse(_currentNumber));
            _currentNumber = _output;
            _newNumber = true;
          }
          break;
        case 'π':
          _currentNumber = math.pi.toString();
          _output = _currentNumber;
          _newNumber = true;
          break;
        case 'e':
          _currentNumber = math.e.toString();
          _output = _currentNumber;
          _newNumber = true;
          break;
        case 'RAD/DEG':
          _isRadianMode = !_isRadianMode;
          break;
        default:
          _currentNumber = _newNumber ? buttonText : _currentNumber + buttonText;
          _output = _currentNumber;
          _newNumber = false;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? backgroundColor, double? width}) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ??
          (buttonText == 'C' ? Colors.pink[100] :
              ['+', '-', '×', '÷', '=', '^'].contains(buttonText) ? Colors.pink[300] :
              ['sin', 'cos', 'tan', '√', 'log', 'ln', 'π', 'e', 'RAD/DEG'].contains(buttonText) ? Colors.pink[400] : Colors.pink[200]),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.all(24.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );

    final textStyle = TextStyle(fontSize: ['sin', 'cos', 'tan', '√', 'log', 'ln', 'π', 'e', 'RAD/DEG'].contains(buttonText) ? 16.0 : 24.0, fontWeight: FontWeight.bold);

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: () => _buttonPressed(buttonText),
          child: Text(buttonText, style: textStyle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator by Safaa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
  icon: Icon(_showScientific ? Icons.power_off : Icons.science), // Replaced science_off
  onPressed: () {
    setState(() {
      _showScientific = !_showScientific;
    });
  },
),
        ],
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _isRadianMode ? 'RAD' : 'DEG',
                  style: TextStyle(fontSize: 14.0, color: Colors.pink[900]),
                ),
                Text(
                  _output,
                  style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.pink[900]),
                ),
              ],
            ),
          ),
          if (_showScientific)
            ...[
              Row(
                children: [
                  Expanded(child: _buildButton('sin')),
                  Expanded(child: _buildButton('cos')),
                  Expanded(child: _buildButton('tan')),
                  Expanded(child: _buildButton('RAD/DEG')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildButton('π')),
                  Expanded(child: _buildButton('e')),
                  Expanded(child: _buildButton('log')),
                  Expanded(child: _buildButton('ln')),
                ],
              ),
            ],
          Expanded(child: Divider()),
          Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildButton('7')),
                  Expanded(child: _buildButton('8')),
                  Expanded(child: _buildButton('9')),
                  Expanded(child: _buildButton('÷')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildButton('4')),
                  Expanded(child: _buildButton('5')),
                  Expanded(child: _buildButton('6')),
                  Expanded(child: _buildButton('×')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildButton('1')),
                  Expanded(child: _buildButton('2')),
                  Expanded(child: _buildButton('3')),
                  Expanded(child: _buildButton('-')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildButton('C')),
                  Expanded(child: _buildButton('0')),
                  Expanded(child: _buildButton('.')),
                  Expanded(child: _buildButton('+')),
                ],
              ),
              Row(
                children: [
                  Expanded(child: _buildButton('±')),
                  Expanded(child: _buildButton('√')),
                  Expanded(child: _buildButton('^')),
                  Expanded(child: _buildButton('=')),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}