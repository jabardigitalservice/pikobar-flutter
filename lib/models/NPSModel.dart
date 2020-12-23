import 'package:meta/meta.dart';

class NPSModel {
  final String id;
  final String score;
  final String feedback;
  final DateTime createdAt;

  NPSModel({this.id, @required this.score, this.feedback, this.createdAt})
      : assert(score != null);

  NPSModel copyWith({
    String id,
    String score,
    String feedback,
    DateTime createdAt,
  }) =>
      NPSModel(
        id: id ?? this.id,
        score: score ?? this.score,
        feedback: feedback ?? this.feedback,
        createdAt: createdAt ?? this.createdAt,
      );

  factory NPSModel.fromJson(Map<String, dynamic> json) => NPSModel(
    id: json["id"],
    score: json["score"],
    feedback: json["feedback"] ?? null,
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "score": score,
    "feedback": feedback ?? null,
    "created_at": createdAt,
  };
}
