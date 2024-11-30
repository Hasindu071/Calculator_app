//##################################### IM/2021/062 Hasindu Thirasara ############################################
import 'package:flutter/material.dart';
import 'dart:math';
import 'history_screen.dart'; // Import the history screen
import 'package:auto_size_text/auto_size_text.dart'; // Import the auto_size_text package

class CalculatorScreen extends StatefulWidget { 
  const CalculatorScreen({super.key});
  
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = ""; // Store the entire input expression
  List<String> history = []; // Store the history of calculations
  bool lastActionWasCalculation = false; // Track if the last action was a calculation
  final int maxNumberLength = 15; // Maximum length for each number

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold( // Scaffold widget
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Output Display
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomRight,
                  child: AutoSizeText(
                    expression.isEmpty ? "0" : expression,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    minFontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            // Divider
            Container(
              height: 0.5,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // History Button
            SizedBox(
              width: screenSize.width * 0.8, // Adjust the width as needed
              height: 50, // Adjust the height as needed
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryScreen(history: history)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 15, 226, 18), // Text color
                  backgroundColor: const Color.fromARGB(255, 54, 59, 62), // Background color
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
                child: const Text("View History"),
              ),
            ),
            // Divider
            Container(
              height: 0.5,
              color: Colors.grey[300],
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
            // Buttons
            Wrap(
              children: _buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == "0" ? screenSize.width / 2 : screenSize.width / 4,
                      height: screenSize.width / 6,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: getBtnTextColor(value),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handle button taps
  void onBtnTap(String value) {
  setState(() {
    if (value == "C") {
      // Clear the expression
      expression = "";
      lastActionWasCalculation = false;
    } else if (value == "D") {
      // Delete the last character
      if (expression.isNotEmpty) {
        expression = expression.substring(0, expression.length - 1);
      }
      lastActionWasCalculation = false;
    } else if (value == "=") {
      // Perform calculation
      calculateResult();
    } else if (value == "+/-") {
      // Toggle negative sign
      toggleNegative();
    } else if (value == "√") {
      // Apply square root
      applySquareRoot();
    } else if (value == "%") {
      // Apply percentage
      applyPercentage();
    } else if (isOperator(value)) {
      // Replace the last operator if one already exists
      if (expression.isNotEmpty) {
        if (isOperator(expression[expression.length - 1])) {
          // Replace the last operator
          expression = expression.substring(0, expression.length - 1) + value;
        } else {
          // Add the operator to the expression
          expression += value;
        }
      }
      lastActionWasCalculation = false;
    } else {
      // Add numbers and decimal point
      if (lastActionWasCalculation) {
        // Reset expression after calculation
        expression = value;
      } else {
        // Prevent adding too many digits
        if (_getCurrentNumber().length < maxNumberLength) {
          // Prevent multiple decimal points
          if (value == "." && _getCurrentNumber().contains(".")) {
            return; // Do not add another decimal point
          }
          expression += value;
        }
      }
      lastActionWasCalculation = false;
    }
  });
}


  // Get the current number being entered
  String _getCurrentNumber() {
    final operators = ['+', '-', '*', '/'];
    for (int i = expression.length - 1; i >= 0; i--) {
      if (operators.contains(expression[i])) {
        return expression.substring(i + 1);
      }
    }
    return expression;
  }

  // Calculate the result of the expression
  void calculateResult() {
    try {
      final processedExpression = preprocessInput(expression);
      final result = evaluateExpression(processedExpression);
      setState(() {
        history.add('$expression = $result');
        expression = result % 1 == 0 ? result.toStringAsFixed(0) : result.toString();
        lastActionWasCalculation = true;
      });
    //  
    } catch (e) {
      setState(() {
        expression = "Cannot divide by zero";
        lastActionWasCalculation = true;
      });
    }
  }

  // Toggle between positive and negative
  void toggleNegative() {
    if (expression.isEmpty) return;
    if (expression.startsWith("-")) {
      expression = expression.substring(1);
    } else {
      expression = "-$expression";
    }
    lastActionWasCalculation = false;
  }
  
  // Apply square root
  void applySquareRoot() {
    if (expression.isEmpty) return; // if expression is empty return nothing
    try {
      double value = double.parse(expression);
      if (value < 0) {
        expression = "Error";
      } else {
        expression = sqrt(value).toString();
      }
    } catch (e) {
      expression = "Error";
    }
    lastActionWasCalculation = false;
  }

  // Apply percentage
  void applyPercentage() {
    if (expression.isEmpty) return;
    try {
      double value = double.parse(expression);
      expression = (value / 100).toString();
    } catch (e) {
      expression = "Error";
    }
    lastActionWasCalculation = false;
  }

  // Preprocess input to handle implicit multiplication
  String preprocessInput(String input) {
    return input
        .replaceAllMapped(RegExp(r'(\d)(\()'), (match) => '${match[1]}*(')
        .replaceAllMapped(RegExp(r'(\))(\d)'), (match) => ')*${match[2]}');
  }

  // Evaluate the mathematical expression
  double evaluateExpression(String exp) {
    final tokens = exp.split(RegExp(r'(?<=[-+*/()])|(?=[-+*/()])'));
    return _evaluateTokens(tokens);
  }

  double _evaluateTokens(List<String> tokens) {
    final operators = <String>[];
    final operands = <double>[];

    for (var token in tokens) {
      if (double.tryParse(token) != null) {
        operands.add(double.parse(token));
      } else if (token == "(") {
        operators.add(token);
      } else if (token == ")") {
        while (operators.isNotEmpty && operators.last != "(") {
          _processOperation(operands, operators.removeLast());
        }
        operators.removeLast(); // Remove the "("
      } else {
        while (operators.isNotEmpty &&
            _precedence(token) <= _precedence(operators.last)) {
          _processOperation(operands, operators.removeLast());
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      _processOperation(operands, operators.removeLast());
    }

    return operands.last;
  }
  // Process the operation
  void _processOperation(List<double> operands, String operator) { // Process the operation0
    final b = operands.removeLast(); // Second operand
    final a = operands.isNotEmpty ? operands.removeLast() : 0.0; // First operand

    switch (operator) {
      case "+":
        operands.add(a + b);
        break;
      case "-":
        operands.add(a - b);
        break;
      case "*":
        operands.add(a * b);
        break;
      case "/":
        if (b == 0) {
          throw Exception("Cannot divide by zero");
        }
        operands.add(a / b);
        break;
    }
  }

  int _precedence(String operator) {
    if (operator == "+" || operator == "-") return 1;
    if (operator == "*" || operator == "/") return 2;
    return 0;
  }

  Color getBtnColor(String value) {
    if (value == "=") {
      return Colors.green;
    }
    return Colors.grey[850]!;
  }

  Color getBtnTextColor(String value) {
    if (isOperator(value) || value == "+/-" || value == "√" || value == "%" || value == "(" || value == ")") {
      return const Color.fromARGB(255, 53, 219, 37);
    }
    if (value == "D" || value == "C") {
      return const Color.fromARGB(255, 220, 37, 37);
    }
    return Colors.white;
  }

  bool isOperator(String value) {
    return value == "+" || value == "-" || value == "*" || value == "/";
  }

  final List<String> _buttonValues = [
    "D",
    "C",
    "(",
    ")",
    "+/-",
    "√",
    "%",
    "+",
    "7",
    "8",
    "9",
    "/",
    "4",
    "5",
    "6",
    "*",
    "1",
    "2",
    "3",
    "-",
    ".",
    "0",
    "="
  ];
}