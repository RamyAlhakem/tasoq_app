import 'package:flutter_sixvalley_ecommerce/data/model/api_list_envelope.dart';
import 'package:flutter_sixvalley_ecommerce/features/review/domain/models/review_model.dart';

class ReviewResponseModel {
  int? totalSize;
  String? averageRating;
  List<GroupWiseRating>? groupWiseRating;
  List<ReviewModel>? reviews;

  ReviewResponseModel({
    this.totalSize,
    this.averageRating,
    this.groupWiseRating,
    this.reviews,
  });

  ReviewResponseModel.fromJson(Map<String, dynamic> json) {
    final envelope = ApiListEnvelope.fromJson(json, legacyKeys: ['reviews']);
    totalSize = envelope.totalSize;

    // v6 sends "4.50" when there are reviews but a bare 0 when there are none.
    averageRating = envelope.read('average_rating')?.toString();

    final dynamic groupWise = envelope.read('group-wise-rating');
    if (groupWise is List) {
      groupWiseRating = <GroupWiseRating>[];
      for (final v in groupWise) {
        groupWiseRating!.add(GroupWiseRating.fromJson(Map<String, dynamic>.from(v)));
      }
    }

    if (envelope.data != null) {
      reviews = <ReviewModel>[];
      for (final v in envelope.data!) {
        reviews!.add(ReviewModel.fromJson(Map<String, dynamic>.from(v)));
      }
    }
  }
}

class GroupWiseRating {
  int? rating;
  int? total;

  GroupWiseRating({this.rating, this.total});

  GroupWiseRating.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    total = json['total'];
  }
}