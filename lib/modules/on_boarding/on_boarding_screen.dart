import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:shop/components/components.dart';
import 'package:shop/modules/login/login_screen.dart';
import 'package:shop/network/local/shared_prefrence.dart';

class OnBoardingModel {
  final String title;
  final String body;
  final String image;

  OnBoardingModel(
      {required this.title, required this.body, required this.image});
}

List<OnBoardingModel> models = [
  OnBoardingModel(
    body: 'On Boarding Body 1',
    title: 'On Boarding Title 1',
    image: 'assets/images/onBoarding_2.jpg',
  ),
  OnBoardingModel(
    body: 'On Boarding Body 2',
    title: 'On Boarding Title 2',
    image: 'assets/images/onBoarding_2.jpg',
  ),
  OnBoardingModel(
    body: 'On Boarding Body 3',
    title: 'On Boarding Title 3',
    image: 'assets/images/onBoarding_2.jpg',
  ),
];

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();

  int currentIndex = 0;
  bool isLastScreen = false;

  void toLoginScreen() {
    ShopCacheHelper.saveData(key: 'onBoarding', value: true);
    navigateAndReplacement(
      context: context,
      widget: const ShopLoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          defaultTextButton(
            isUpperCase: true,
            color: Colors.white,
            text: 'skip',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            onPressed: toLoginScreen,
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          onBoardingContent(context, models[currentIndex]),
          onBoardingIndicator(models[currentIndex]),
        ],
      ),
    );
  }

  Widget onBoardingContent(context, OnBoardingModel model) => PageView.builder(
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          if (index == models.length - 1) {
            setState(() {
              isLastScreen = true;
            });
          } else {
            setState(() {
              isLastScreen = false;
            });
          }
          setState(() {
            currentIndex = index;
          });
        },
        controller: pageController,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage(
                        model.image,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    model.body,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                ],
              ),
            ],
          ),
        ),
        itemCount: models.length,
      );

  Widget onBoardingIndicator(OnBoardingModel model) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            PageViewIndicator(
              currentIndex: currentIndex,
              length: models.length,
              animationDuration: const Duration(milliseconds: 600),
              otherColor: Colors.grey,
              currentColor: Colors.deepPurple,
            ),
            const Spacer(),
            FloatingActionButton(
              onPressed: () {
                if (isLastScreen) {
                  toLoginScreen();
                } else {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.fastLinearToSlowEaseIn);
                }
              },
              child: const Icon(
                Icons.arrow_forward_ios,
              ),
            ),
          ],
        ),
      );
}
