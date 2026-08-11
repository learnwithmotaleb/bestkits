import 'package:get/get.dart';

class ReviewDummyModel {
  final String initials;
  final String name;
  final String rating;
  final String date;
  final String content;

  ReviewDummyModel({
    required this.initials,
    required this.name,
    required this.rating,
    required this.date,
    required this.content,
  });
}

class ViewAllReviewController extends GetxController {
  final RxList<ReviewDummyModel> reviews = <ReviewDummyModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyReviews();
  }

  void _loadDummyReviews() {
    reviews.assignAll([
      ReviewDummyModel(
        initials: "LT",
        name: "Liam Thompson",
        rating: "4.9/5.0",
        date: "15 Mar 2026",
        content: "These sneakers are super comfy and lightweight! My kid wears them daily, and they still look fantastic. The fit is spot on, and they're easy to slip on. A great buy!",
      ),
      ReviewDummyModel(
        initials: "EB",
        name: "Ethan Brown",
        rating: "4.8/5.0",
        date: "20 Mar 2026",
        content: "Overall, the quality is impressive and the design is stylish. The material feels robust and perfect for everyday wear. The delivery was seamless and the packaging was excellent. I'm pleased with my purchase.",
      ),
      ReviewDummyModel(
        initials: "SK",
        name: "Sophie Klein",
        rating: "4.8/5.0",
        date: "20 Feb 2026",
        content: "Just as described! The sneakers are sleek and well-crafted, and the size is just right. My child finds them very comfy for both school and outdoor activities. Highly recommend!",
      ),
      ReviewDummyModel(
        initials: "MS",
        name: "Mason Schmidt",
        rating: "4.9/5.0",
        date: "05 Feb 2026",
        content: "These sneakers are both stylish and comfortable. The sole provides excellent grip, and the quality feels sturdy. They were a bit tight initially, but they fit better after a few wears. Overall, a solid value.",
      ),
      ReviewDummyModel(
        initials: "LT",
        name: "Liam Thompson",
        rating: "4.7/5.0",
        date: "15 Mar 2027",
        content: "These sneakers are incredibly comfortable and light! My child wears them every day, and they still look amazing. The fit is perfect, and they're super easy to put on. Definitely a smart purchase!",
      ),
      ReviewDummyModel(
        initials: "MB",
        name: "Mason Brown",
        rating: "4.9/5.0",
        date: "10 Apr 2025",
        content: "These sneakers are so comfy and lightweight! My kid wears them all the time, and they still look great. The fit is just right, and they're easy to slip on. A fantastic choice!",
      ),
      ReviewDummyModel(
        initials: "JW",
        name: "James Wilson",
        rating: "4.6/5.0",
        date: "22 Jan 2026",
        content: "These sneakers are super cozy and light! My child wears them daily, and they still look awesome. The fit is perfect, and they're easy to slip on. A great purchase!",
      ),
      ReviewDummyModel(
        initials: "EM",
        name: "Ethan Martinez",
        rating: "4.8/5.0",
        date: "30 May 2026",
        content: "These sneakers are super comfy and lightweight! My kid wears them every day, and they still look fantastic. The fit is just right, and they're easy to slip on. A great buy!",
      ),
      ReviewDummyModel(
        initials: "NR",
        name: "Noah Rodriguez",
        rating: "4.9/5.0",
        date: "5 Jun 2025",
        content: "These sneakers are super comfy and lightweight! My kid wears them daily, and they still look amazing. The fit is spot on, and they're easy to slip on. A fantastic buy!",
      ),
    ]);
  }
}