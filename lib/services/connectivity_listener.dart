import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({required this.child, super.key});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool hasConnection = true;

  @override
  void initState() {
    super.initState();
    _initialCheck();

    subscription = Connectivity().onConnectivityChanged.listen((results) async {
      await _handleConnectivityChange(results);
    });
  }

  Future<void> _initialCheck() async {
    final results = await Connectivity().checkConnectivity();
    await _handleConnectivityChange(results);
  }

  Future<void> _handleConnectivityChange(List<ConnectivityResult> results) async {
    final isConnected = results.any((r) => r != ConnectivityResult.none) && await _checkInternet();

    if (mounted) {
      setState(() {
        hasConnection = isConnected;
      });
    }
  }

  Future<bool> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!hasConnection)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: const Text(
                'Немає інтернет-зʼєднання',
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
