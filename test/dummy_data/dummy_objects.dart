import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_response.dart';
import 'package:laporhoax/data/models/user_token.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';

final testFeed = Feed(
  id: 1,
  title: "title",
  content: "content",
  thumbnail: "thumbnail",
  date: "date",
  view: 0,
  author: 1,
);

final testFeedList = [testFeed];

final testReport = Report(
  id: 1,
  url: "url",
  img: "img",
  category: "category",
  status: "status",
  isAnonym: false,
  dateReported: "dateReported",
  description: "description",
  prosesDate: "prosesDate",
  verdict: "verdict",
  verdictDesc: "verdictDesc",
  verdictDate: "verdictDate",
  user: 1,
  verdictJudge: 1,
);

final testReportList = [testReport];

final testSessionData = SessionData(
  token: "token",
  expiry: "expiry",
  userid: 1,
  username: "username",
  email: "email",
);

final testUserChallenge = UserQuestion(
  user: "user",
  quest1: 1,
  quest2: 2,
  quest3: 3,
  ans1: "ans1",
  ans2: "ans2",
  ans3: "ans3",
);

final testUser = User(
  id: 1,
  username: "username",
  email: "email",
);

final testUserModel = UserModel(
  id: 1,
  username: "username",
  email: "email",
);

final testLogin = UserToken(
  token: "token",
  expiry: "expiry",
);

final testRegister = RegisterModel(
  name: "name",
  email: "email",
  password: "password",
);

final testRegisterCallback = UserResponse(
  user: testUserModel,
  token: "token",
);

final testFeedTable = FeedTable(
  id: 1,
  title: "title",
  thumbnail: "thumbnail",
  date: "date",
);

final testFeedMap = {
  'id': 1,
  'title': 'title',
  'thumbnail': 'thumbnail',
  'date': 'date'
};
