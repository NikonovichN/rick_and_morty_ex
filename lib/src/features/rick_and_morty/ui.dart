import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'repository.dart';

import 'controller.dart';

class RickAndMortyScreen extends StatelessWidget {
  const RickAndMortyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<RickAndMortyRepository>();
    final controller = RickAndMortyScreenControllerImpl(repository: repository);

    controller.loadData();

    return StreamBuilder<RickAndMortyScreenState>(
      stream: controller.stream,
      builder: (context, snapshot) {
        return SizedBox();
      },
    );
  }
}
