// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String message;
    UserClass user;

    User({
        required this.message,
        required this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        message: json["message"],
        user: UserClass.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
    };
}

class UserClass {
    int id;
    String username;
    String displayName;
    String targetExam;
    DateTime examDate;
    DateTime memberSince;
    String role;
    String email;
    dynamic phoneNumber;
    bool emailVerified;
    bool isActive;
    DateTime lastLogin;
    String examYear;
    String dreamRank;
    int weeklyTargetQuestions;
    int weeklyTargetRevisionHours;
    int weeklyTargetStudyHours;
    dynamic accuracyTarget;
    dynamic percentileTarget;
    bool onboardingCompleted;
    bool baselineAssessmentCompleted;

    UserClass({
        required this.id,
        required this.username,
        required this.displayName,
        required this.targetExam,
        required this.examDate,
        required this.memberSince,
        required this.role,
        required this.email,
        required this.phoneNumber,
        required this.emailVerified,
        required this.isActive,
        required this.lastLogin,
        required this.examYear,
        required this.dreamRank,
        required this.weeklyTargetQuestions,
        required this.weeklyTargetRevisionHours,
        required this.weeklyTargetStudyHours,
        required this.accuracyTarget,
        required this.percentileTarget,
        required this.onboardingCompleted,
        required this.baselineAssessmentCompleted,
    });

    factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        username: json["username"],
        displayName: json["displayName"],
        targetExam: json["targetExam"],
        examDate: DateTime.parse(json["examDate"]),
        memberSince: DateTime.parse(json["memberSince"]),
        role: json["role"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        emailVerified: json["emailVerified"],
        isActive: json["isActive"],
        lastLogin: DateTime.parse(json["lastLogin"]),
        examYear: json["examYear"],
        dreamRank: json["dreamRank"],
        weeklyTargetQuestions: json["weeklyTargetQuestions"],
        weeklyTargetRevisionHours: json["weeklyTargetRevisionHours"],
        weeklyTargetStudyHours: json["weeklyTargetStudyHours"],
        accuracyTarget: json["accuracyTarget"],
        percentileTarget: json["percentileTarget"],
        onboardingCompleted: json["onboardingCompleted"],
        baselineAssessmentCompleted: json["baselineAssessmentCompleted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "displayName": displayName,
        "targetExam": targetExam,
        "examDate": "${examDate.year.toString().padLeft(4, '0')}-${examDate.month.toString().padLeft(2, '0')}-${examDate.day.toString().padLeft(2, '0')}",
        "memberSince": memberSince.toIso8601String(),
        "role": role,
        "email": email,
        "phoneNumber": phoneNumber,
        "emailVerified": emailVerified,
        "isActive": isActive,
        "lastLogin": lastLogin.toIso8601String(),
        "examYear": examYear,
        "dreamRank": dreamRank,
        "weeklyTargetQuestions": weeklyTargetQuestions,
        "weeklyTargetRevisionHours": weeklyTargetRevisionHours,
        "weeklyTargetStudyHours": weeklyTargetStudyHours,
        "accuracyTarget": accuracyTarget,
        "percentileTarget": percentileTarget,
        "onboardingCompleted": onboardingCompleted,
        "baselineAssessmentCompleted": baselineAssessmentCompleted,
    };
}
