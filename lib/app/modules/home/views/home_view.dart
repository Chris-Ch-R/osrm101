import 'dart:async';
import 'dart:developer' as developer;

import 'package:facgure_test/app/modules/store_detail/views/store_detail_view.dart';
import 'package:facgure_test/app/widgets/store_list_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDistanceChoice(),
          _buildRattingChoice(),
          const StoreList(),
        ],
      ),
    );
  }

  Widget _buildDistanceChoice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => ChoiceChip(
            avatar: controller.selectedChoice!.value == 1
                ? const Icon(Icons.check)
                : null,
            label: const Text('distance ASC'),
            selected: controller.selectedChoice!.value == 1,
            onSelected: (bool selected) {
              print(selected);
              if (selected) {
                controller.sortDistanceASC();
                controller.selectedChoice!.value = 1;
              }
            },
          ),
        ),
        Obx(
          () => ChoiceChip(
            avatar: controller.selectedChoice!.value == 2
                ? const Icon(Icons.check)
                : null,
            label: const Text('distance DESC'),
            selected: controller.selectedChoice!.value == 2,
            onSelected: (bool selected) {
              print(selected);
              if (selected) {
                controller.sortDistanceDESC();
                controller.selectedChoice!.value = 2;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRattingChoice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => ChoiceChip(
            avatar: controller.selectedChoice!.value == 3
                ? const Icon(Icons.check)
                : null,
            label: const Text('rating ASC'),
            selected: controller.selectedChoice!.value == 3,
            onSelected: (bool selected) {
              print(selected);
              if (selected) {
                controller.sortRattingASC();
                controller.selectedChoice!.value = 3;
              }
            },
          ),
        ),
        Obx(
          () => ChoiceChip(
            avatar: controller.selectedChoice!.value == 4
                ? const Icon(Icons.check)
                : null,
            label: const Text('rating DESC'),
            selected: controller.selectedChoice!.value == 4,
            onSelected: (bool selected) {
              if (selected) {
                controller.sortRattingDESC();
                controller.selectedChoice!.value = 4;
              }
            },
          ),
        ),
      ],
    );
  }
}
