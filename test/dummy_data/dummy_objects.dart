import 'package:laporhoax/data/models/category_model.dart';
import 'package:laporhoax/data/models/category_table.dart';
import 'package:laporhoax/data/models/feed_model.dart';
import 'package:laporhoax/data/models/feed_table.dart';
import 'package:laporhoax/data/models/question_model.dart';
import 'package:laporhoax/data/models/question_table.dart';
import 'package:laporhoax/data/models/register_model.dart';
import 'package:laporhoax/data/models/register_response.dart';
import 'package:laporhoax/data/models/report_model.dart';
import 'package:laporhoax/data/models/user_model.dart';
import 'package:laporhoax/data/models/user_question_model.dart';
import 'package:laporhoax/data/models/user_token_model.dart';
import 'package:laporhoax/domain/entities/category.dart';
import 'package:laporhoax/domain/entities/feed.dart';
import 'package:laporhoax/domain/entities/question.dart';
import 'package:laporhoax/domain/entities/register.dart';
import 'package:laporhoax/domain/entities/register_data.dart';
import 'package:laporhoax/domain/entities/report.dart';
import 'package:laporhoax/domain/entities/session_data.dart';
import 'package:laporhoax/domain/entities/user.dart';
import 'package:laporhoax/domain/entities/user_question.dart';
import 'package:laporhoax/domain/entities/user_token.dart';

final testFeed = Feed(
  id: 26,
  title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
  content: "content",
  thumbnail:
      "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
  date: "2021-10-13T01:34:58.831621+07:00",
  view: 0,
  author: 1,
);

final testFeedModel = FeedModel(
  id: 26,
  title: "Libur Maulid Nabi 2021 Digeser: Tanggal dan Alasannya",
  content: "content",
  thumbnail:
      "https://django-lapor-hoax.s3.amazonaws.com/feeds/1.jpeg?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=yXthBiGVfwxxC%2Flai%2FvL0PZAMz4%3D&Expires=1634826461",
  date: "2021-10-13T01:34:58.831621+07:00",
  view: 0,
  author: 1,
);

final testFeedList = [testFeed];

final testFeedModelList = [testFeedModel];

final testReportModel = ReportModel(
  id: 59,
  url: "www.aslihoax.com",
  img:
      "https://django-lapor-hoax.s3.amazonaws.com/reports/Capture.PNG?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=6eGLu1R0U3qsyUf5sb%2B2up%2B9DzU%3D&Expires=1634827154",
  category: "Isu SARA",
  status: "Selesai",
  isAnonym: false,
  dateReported: "2021-10-13T03:33:41.647173+07:00",
  description: "Menyebarkan berita hoax",
  prosesDate: "2021-10-15T03:52:34.695336+07:00",
  verdict: "Diterima",
  verdictDesc: "respon",
  verdictDate: "2021-10-15T04:01:28.042973+07:00",
  user: 1,
  verdictJudge: 1,
);

final testReport = Report(
  id: 59,
  url: "www.aslihoax.com",
  img:
      "https://django-lapor-hoax.s3.amazonaws.com/reports/Capture.PNG?AWSAccessKeyId=AKIAXSGIDQGEESDBZHGJ&Signature=6eGLu1R0U3qsyUf5sb%2B2up%2B9DzU%3D&Expires=1634827154",
  category: "Isu SARA",
  status: "Selesai",
  isAnonym: false,
  dateReported: "2021-10-13T03:33:41.647173+07:00",
  description: "Menyebarkan berita hoax",
  prosesDate: "2021-10-15T03:52:34.695336+07:00",
  verdict: "Diterima",
  verdictDesc: "respon",
  verdictDate: "2021-10-15T04:01:28.042973+07:00",
  user: 1,
  verdictJudge: 1,
);

final testReportList = [testReport];

final testSessionData = SessionData(
  token: "token",
  expiry: "expiry",
  userid: 1,
  email: "email",
  username: 'useranme',
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

final testUserChallengeModel = UserQuestionModel(
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

final testLoginModel = UserTokenModel(
  token: "token",
  expiry: "expiry",
);

final testLogin = UserToken(
  token: "token",
  expiry: "expiry",
);

final testRegisterModel = RegisterModel(
  name: "name",
  email: "email",
  password: "password",
);

final testRegister = Register(
  name: "name",
  email: "email",
  password: "password",
);

final testRegisterCallback = RegisterResponse(
  user: testUserModel,
  token: "token",
);

final testRegisterData = RegisterData(
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

final testCategory = Category(id: 1, name: 'name');

final testCategoryTable = CategoryTable(id: 1, name: 'name');

final testCategoryModel = CategoryModel(id: 1, name: 'name');

final testCategoryMap = {'id': 1, 'name': 'name'};

final testQuestion = Question(id: 1, question: 'question');

final testQuestionTable = QuestionTable(id: 1, question: 'question');

final testQuestionModel = QuestionModel(id: 1, question: 'question');

final testQuestionMap = {'id': 1, 'question': 'question'};

final testQuestionToMap = {1 : 'question'};
