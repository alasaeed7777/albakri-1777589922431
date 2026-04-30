```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ø­Ø§Ø³Ø¨Ù',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1E88E5),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _expression = '';
  double _firstOperand = 0;
  String _operator = '';
  bool _isOperatorPressed = false;
  bool _isResultShown = false;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isResultShown) {
        _display = digit;
        _expression = digit;
        _isResultShown = false;
        _operator = '';
        _firstOperand = 0;
      } else if (_display == '0' && digit != '.') {
        _display = digit;
        _expression = digit;
      } else {
        _display += digit;
        _expression += digit;
      }
      _isOperatorPressed = false;
    });
  }

  void _onOperatorPressed(String op) {
    setState(() {
      if (_isOperatorPressed) {
        _operator = op;
        return;
      }
      if (_operator.isNotEmpty && !_isResultShown) {
        _calculateResult();
      }
      _firstOperand = double.parse(_display);
      _operator = op;
      _isOperatorPressed = true;
      _isResultShown = false;
      _expression = '$_firstOperand $op ';
    });
  }

  void _onEqualsPressed() {
    if (_operator.isEmpty) return;
    setState(() {
      _calculateResult();
      _isResultShown = true;
      _operator = '';
    });
  }

  void _calculateResult() {
    final double secondOperand = double.parse(_display);
    double result = 0;
    switch (_operator) {
      case '+':
        result = _firstOperand + secondOperand;
        break;
      case '-':
        result = _firstOperand - secondOperand;
        break;
      case 'Ã':
        result = _firstOperand * secondOperand;
        break;
      case 'Ã·':
        result = secondOperand != 0 ? _firstOperand / secondOperand : double.infinity;
        break;
    }
    _display = result == double.infinity ? 'Error' : _formatResult(result);
    _expression = '$_firstOperand $_operator $secondOperand =';
    _firstOperand = result;
  }

  String _formatResult(double value) {
    if (value == value.floorToDouble() && !value.isInfinite) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  void _onClearPressed() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = 0;
      _operator = '';
      _isOperatorPressed = false;
      _isResultShown = false;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
        _expression = _expression.substring(0, _expression.length - 1);
      } else {
        _display = '0';
        _expression = '';
      }
    });
  }

  void _onDecimalPressed() {
    if (_display.contains('.')) return;
    setState(() {
      _display += '.';
      _expression += '.';
    });
  }

  void _onPercentagePressed() {
    setState(() {
      final double value = double.parse(_display) / 100;
      _display = _formatResult(value);
      _expression = '$_display %';
    });
  }

  void _onNegatePressed() {
    setState(() {
      if (_display.startsWith('-')) {
        _display = _display.substring(1);
        _expression = _expression.substring(1);
      } else {
        _display = '-$_display';
        _expression = '-$_expression';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ø­Ø§Ø³Ø¨Ù'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _expression,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          _buildButtonGrid(theme),
        ],
      ),
    );
  }

  Widget _buildButtonGrid(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              _buildButton('C', theme.colorScheme.error, Colors.white),
              _buildButton('â«', theme.colorScheme.secondaryContainer, theme.colorScheme.onSecondaryContainer),
              _buildButton('%', theme.colorScheme.secondaryContainer, theme.colorScheme.onSecondaryContainer),
              _buildButton('Ã·', theme.colorScheme.primary, Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('7', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('8', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('9', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('Ã', theme.colorScheme.primary, Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('4', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('5', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('6', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('-', theme.colorScheme.primary, Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('1', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('2', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('3', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('+', theme.colorScheme.primary, Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildButton('Â±', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('0', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('.', theme.colorScheme.surfaceVariant, theme.colorScheme.onSurfaceVariant),
              _buildButton('=', theme.colorScheme.primary, Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color backgroundColor, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: () => _onButtonPressed(text),
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  void _onButtonPressed(String text) {
    switch (text) {
      case 'C':
        _onClearPressed();
        break;
      case 'â«':
        _onDeletePressed();
        break;
      case 'Â±':
        _onNegatePressed();
        break;
      case '%':
        _onPercentagePressed();
        break;
      case '+':
      case '-':
      case 'Ã':
      case 'Ã·':
        _onOperatorPressed(text);
        break;
      case '=':
        _onEqualsPressed();
        break;
      case '.':
        _onDecimalPressed();
        break;
      default:
        _onDigitPressed(text);
    }
  }
}
```