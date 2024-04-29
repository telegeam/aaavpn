import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/service/user_service.dart';
import 'package:sail/utils/l10n.dart';
import 'package:sail/utils/navigator_util.dart';
import 'package:sail/widgets/bottom_block.dart';
import 'package:sail/widgets/profile_widget.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile> {
  late UserModel _userModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userModel = Provider.of<UserModel>(context);
  }

  void onLogoutTap() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(context.l10n.alertsss),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(
                    context.l10n.wanttoexit,
                    style: TextStyle(fontSize: 18),
                  ),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(context.l10n.cancelss),
                onPressed: () {
                  Navigator.pop(context);
                  //print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text(
                  context.l10n.exitout,
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  //print("确定");
                  _userModel.logout();
                  NavigatorUtil.goLogin(context);
                },
              ),
            ],
          );
        });
  }

  void onWebLinkTap(String name, String link) => _userModel.checkHasLogin(
      context,
      () => UserService().getQuickLoginUrl({'redirect': link})?.then((value) {
            NavigatorUtil.goWebView(context, name, value);
          }));

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                right: ScreenUtil().setWidth(32),
                left: ScreenUtil().setWidth(32),
                top: ScreenUtil().setHeight(32),
                bottom: ScreenUtil().setHeight(32)),
            child: Material(
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Column(
                  children: <Widget>[
                    ProfileWidget(
                      avatar: _userModel.userEntity?.avatarUrl,
                      userName: _userModel.userEntity?.email ?? "欢迎光临",
                      onTap: onLogoutTap,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!)),
                        ),
                      ),
                    ),
                    FinanceWidget(onWebLinkTap: onWebLinkTap),
                    Container(
                      padding: const EdgeInsets.only(top: 24, bottom: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey[300]!)),
                        ),
                      ),
                    ),
                    AccountWidget(onWebLinkTap: onWebLinkTap),
                  ],
                ),
              ),
            ),
          ),
          const BottomBlock(),
        ],
      ),
    ));
  }
}

class AccountWidget extends StatelessWidget {
  const AccountWidget({Key? key, required this.onWebLinkTap}) : super(key: key);

  final dynamic onWebLinkTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "账户",
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => onWebLinkTap("个人中心", '/profile'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "🙍 个人中心",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => onWebLinkTap("我的工单", "/ticket"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "🎫 我的工单",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => onWebLinkTap("流量明细", "traffic"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "🔖 流量明细",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FinanceWidget extends StatelessWidget {
  const FinanceWidget({Key? key, required this.onWebLinkTap}) : super(key: key);

  final dynamic onWebLinkTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "财务",
                  style: TextStyle(
                    color: Color(0xFFADADAD),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => onWebLinkTap("我的订单", "/order"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "💳 我的订单",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => onWebLinkTap("我的邀请", "/invite"),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "🫲 我的邀请",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
