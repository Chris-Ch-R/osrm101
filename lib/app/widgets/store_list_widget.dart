import 'package:facgure_test/app/modules/home/controllers/home_controller.dart';
import 'package:facgure_test/app/modules/store_detail/views/store_detail_view.dart';
import 'package:facgure_test/app/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skeletons/skeletons.dart';

class StoreList extends StatelessWidget {
  const StoreList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: ((controller) => Obx(
              () => Expanded(
                  child: Container(
                padding: EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: ((context) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                  ),
                                )));
                        controller
                            .getPolyline(
                                controller
                                    .mockStoreList[index].location.latitude,
                                controller
                                    .mockStoreList[index].location.longitude)
                            .then((value) {
                          Get.back();
                          Get.to(() => const StoreDetailView(), arguments: {
                            "polyline": value,
                            "currentLocation": LatLng(
                                controller.currentLocation!.latitude,
                                controller.currentLocation!.longitude),
                            "destination": controller.mockStoreList[index]
                          });
                        });
                      },
                      child: FutureBuilder(
                        future: controller.getDistance(
                            index,
                            controller.mockStoreList[index].location.latitude,
                            controller.mockStoreList[index].location.longitude),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('errorr');
                          }
                          if (!snapshot.hasData) {
                            return SkeletonListTile(
                              hasLeading: true,
                              hasSubtitle: true,
                            );
                          }
                          return Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                    width: 50,
                                    height: 50,
                                    controller.mockStoreList[index].img!),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(controller.mockStoreList[index].name),
                                  Text(
                                      'distance ${(snapshot.data! / 1000).toStringAsFixed(2)} km'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Text(
                                          "${controller.mockStoreList[index].ratting}")
                                    ],
                                  )
                                ],
                              )
                            ],
                          );
                          // return ListTile(
                          //     leading: Container(
                          //       width: 50,
                          //       height: 50,
                          //       child: Image.network(
                          //           width: 50,
                          //           height: 50,
                          //           controller.mockStoreList[index].img!),
                          //     ),
                          //     title: Text(
                          //       controller.mockStoreList[index].name,
                          //     ),
                          //     subtitle: Text(
                          //         'distance ${(snapshot.data! / 1000).toStringAsFixed(2)} km'));
                        },
                      ),
                    );
                  },
                  itemCount: controller.mockStoreList.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      indent: 10,
                      endIndent: 10,
                      color: AppTheme.kColorsDarkGrey,
                    );
                  },
                ),
              )),
            )
        )
    );
  }
}
