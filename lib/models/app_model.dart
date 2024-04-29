import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sail/adapters/leaf_ffi/config.dart';
import 'package:sail/channels/Platform.dart';
import 'package:sail/channels/vpn_manager.dart';
import 'package:sail/constant/app_colors.dart';
import 'package:sail/constant/app_strings.dart';
import 'package:sail/models/base_model.dart';
import 'package:sail/models/server_model.dart';
import 'package:sail/models/user_model.dart';
import 'package:sail/utils/common_util.dart';

class AppModel extends BaseModel {
  VpnManager vpnManager = VpnManager();
  VpnStatus vpnStatus = VpnStatus.disconnected;
  bool isOn = false;
  bool isconnectordisconnct = false;
  DateTime? connectedDate;
  PageController pageController = PageController(initialPage: 0);
  String appTitle = AppStrings.appName;
  Config config = Config();
  ThemeData themeData = ThemeData(
    primarySwatch: AppColors.themeColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  AppModel() {
    General general = General(
        loglevel: 'info',
        logoutput: '{{leafLogFile}}',
        dnsServer: ['223.5.5.5', '114.114.114.114'],
        tunFd: '{{tunFd}}',
        apiInterface: '127.0.0.1',
        apiPort: 1087,
        socksInterface: '127.0.0.1',
        socksPort: 1086,
        alwaysRealIp: ['tracker', 'apple.com'],
        routingDomainResolve: true);

    List<Rule> rules = [];
    // rules.add(Rule(typeField: 'EXTERNAL', target: 'Direct', filter: 'site:cn'));
    rules.add(Rule(typeField: 'FINAL', target: 'Direct'));

    config.general = general;
    config.rules = rules;
  }

  final Map _tabMap = {
    0: '主页',
    1: '套餐',
    2: '节点',
    3: '我的',
  };

  void jumpToPage(int page) {
    // pageController.jumpToPage(page);
    appTitle = _tabMap[page];

    notifyListeners();
  }

  void getStatus() async {
    vpnStatus = await vpnManager.getStatus();

    if (vpnStatus == VpnStatus.connected) {
      isOn = true;

      getConnectedDate();
      notifyListeners();
    } else if (vpnStatus == VpnStatus.disconnected) {
      isOn = false;
      notifyListeners();
    } else {
      isconnectordisconnct = true;
      notifyListeners();
    }
  }

  void getConnectedDate() async {
    if (Platform.isAndroid || Platform.isMacOS) {
    } else {
      var date = await vpnManager.getConnectedDate();
      //print("date: $date");
      connectedDate = date;
    }
  }

  void togglePowerButton() async {
    if (vpnStatus == VpnStatus.connecting) {
      Fluttertoast.showToast(
          msg: "Connecting, please wait...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }

    if (vpnStatus == VpnStatus.disconnecting) {
      Fluttertoast.showToast(
          msg: "Disconnecting, please wait...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          textColor: Colors.white,
          fontSize: 14.0);
      return;
    }

    if (vpnStatus == VpnStatus.connected) {
      vpnStatus = VpnStatus.disconnecting;
    }

    if (vpnStatus == VpnStatus.disconnected) {
      vpnStatus = VpnStatus.connecting;
    }

    await vpnManager.toggle();

    notifyListeners();
  }

  void getTunnelLog() async {
    if (Platform.isIOS) {
      var log = await vpnManager.getTunnelLog();
      print("log: $log");
    }
  }

  void getTunnelConfiguration() async {
    if (Platform.isIOS) {
      var conf = await vpnManager.getTunnelConfiguration();
      print("config: $conf");
    }
  }

  void setConfigProxies(UserModel userModel, ServerModel serverModel) async {
    List<Proxy> proxies = [];
    List<ProxyGroup> proxyGroups = [];
    List<String> actors = [];

    for (var server in serverModel.serverEntityList) {
      Proxy proxy = Proxy(
          tag: server.name,
          protocol: server.type,
          address: server.host,
          port: server.port,
          encryptMethod: server.cipher,
          password: userModel.userEntity!.uuid);
      proxies.add(proxy);
      actors.add(server.name);
    }

    if (actors.isNotEmpty) {
      proxyGroups.add(ProxyGroup(
          tag: "UrlTest",
          protocol: 'url-test',
          actors: actors,
          checkInterval: 600));

      config.rules?.last.target = "UrlTest";
    }

    config.proxies = proxies;
    config.proxyGroups = proxyGroups;

    print("-----------------config-----------------");
    print(config);
    print("-----------------config-----------------");

    vpnManager.setTunnelConfiguration(config.toString());
  }

  void setConfigRule(String tag) async {
    var proxy = config.proxies?.where((proxies) => proxies.tag == tag);
    
    if (proxy == null || proxy.isEmpty) {
      return;
    }
    
    config.rules?.last.target = tag;
    
    print("-----------------config-----------------");
    print(config);
    print("-----------------config-----------------");
    
    vpnManager.setTunnelConfiguration(config.toString());
  }
}
