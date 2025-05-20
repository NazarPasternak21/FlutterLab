
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/qr/qr_cubit.dart';
import 'package:my_project/cubit/qr/qr_state.dart';

class SavedQrScreen extends StatelessWidget {
  const SavedQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Збережений QR')),
      body: Center(
        child: BlocBuilder<QRCubit, QRState>(
          builder: (context, state) {
            if (state is QRLoading) {
              return const CircularProgressIndicator();
            } else if (state is QRSuccess) {
              return Text(state.data,
                  style: const TextStyle(fontSize: 18));
            } else if (state is QRFailure) {
              return Text("Помилка: ${state.error}",
                  style: const TextStyle(color: Colors.red));
            } else {
              return ElevatedButton(
                onPressed: () {
                  context.read<QRCubit>().scanFromArduino();
                },
                child: const Text('Зчитати з Arduino'),
              );
            }
          },
        ),
      ),
    );
  }
}
