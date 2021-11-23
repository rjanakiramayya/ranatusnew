import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:renatus/Controllers/homecontroller.dart';
import 'package:renatus/Utils/constants.dart';
import 'package:renatus/Utils/session_manager.dart';
import 'package:renatus/Views/web_view.dart';
import 'package:renatus/Widgets/main_drawer.dart';

class MainView extends StatelessWidget {
  static const String routeName = '/MainView';
  final homeController = Get.put(HomeController());
  final ScrollController controller = ScrollController();

  MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          '${Constants.iconPath}rlogo.png',
          height: 40,
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return InkWell(
              child: Image.asset(
                '${Constants.iconPath}drawericon.png',
              ),
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Obx(() {
        return homeController.isLoading.value
            ? const Center()
            : homeController.isError.value
                ? Center(
                    child: TextButton(
                        onPressed: () => homeController.getHomeData(),
                        child: const Text('Something Went Wrong Refresh')),
                  )
                : SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                              height: 200,
                              autoPlay: true,
                              viewportFraction: 1,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              aspectRatio: 2.0),
                          items: homeController.homeData.Banners!.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return CachedNetworkImage(
                                    imageUrl:
                                        'https://ik.imagekit.io/renatuswellness/${i!.BannerUrl ?? ''}',
                                    placeholder: (context, url) => const Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                    errorWidget: (context, url, error) => Align(
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              '${Constants.imagePath}No_Product.png'),
                                        ),
                                    width: Get.width-10,
                                    height: 200,
                                    fit: BoxFit.fill);
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          color: Constants.hexToColor('#F5F5F7'),
                          height: 220,
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int i) {
                              return Container(
                                width: Get.width / 2,
                                margin:
                                    const EdgeInsets.all(Constants.paddingM),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white30,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      width: Get.width / 2,
                                      child: CachedNetworkImage(
                                        height: 170,
                                        width: 170,
                                        imageUrl:
                                            "https://ik.imagekit.io/renatuswellness/${homeController.homeData.Products![i]!.ProductImage}",
                                        imageBuilder: (ctx, imageProvide) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            image: DecorationImage(
                                                image: imageProvide,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => Container(
                                            child: const Center(
                                                child:
                                                    CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                child: Image.asset(
                                                    '${Constants.imagePath}No_Product.png')),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: Get.width / 2,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        homeController.homeData.Products![i]!
                                                .ProductName ??
                                            '',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: homeController.homeData.Products!.length,
                          ),
                        ),
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                '${Constants.imagePath}product.png',
                                width: 130,
                                height: 170,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'RENATUS NOVA',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange),
                                    ),
                                    const SizedBox(height: 5,),
                                    const Text(
                                      'Renatus Nova® is studded with 9 ingredients which directly originates from the laps of nature. All of these nutrients consists of some unique quality which helps our body and mind immensely.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.red),
                                      width: 100,
                                      height: 32,
                                      child: TextButton(
                                        onPressed: () => {
                                        },
                                        child: const Text(
                                          'Shop Now',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Image.asset('${Constants.imagePath}fotter.png',width: Get.width,height: 200,fit: BoxFit.fill,),
                      ],
                    ),
                  );
      }),
      drawer: MianDrawer(),
    );
  }
}
