import 'package:flutter/material.dart';
import 'package:rootanya/redux/login/login_state.dart';
import 'package:rootanya/ui/common/loading_content.dart';
import 'package:rootanya/ui/common/loading_view.dart';
import 'package:rootanya/ui/common/ripple_button.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/login';

  final Function(String, String, BuildContext) onLogin;
  final LoginState loginState;

  LoginScreen({
    this.onLogin,
    this.loginState,
  });

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//  final TextEditingController _emailController =  TextEditingController(text: 'natthapon@mail.com');
//  final TextEditingController _passwordController =  TextEditingController(text: '123456');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _passwordNode = FocusNode();

  void _login(BuildContext scaffoldContext) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    widget.onLogin(_emailController.text, _passwordController.text, scaffoldContext);
  }

  void _showRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  Widget _buildInitialContent(BuildContext scaffoldContext) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(height: 32.0),
          Image.asset(
            'assets/icons/med_icon_circle.png',
            width: 150.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Text(
                'รู้ทันยา',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'อีเมลล์'),
                    controller: _emailController,
                    validator: (val) => val.isEmpty ? 'กรุณากรอกอีเมลล์' : null,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordNode),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'รหัสผ่าน'),
                    controller: _passwordController,
                    validator: (val) => val.isEmpty ? 'กรุณากรอกรหัสผ่าน' : null,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: _passwordNode,
                    obscureText: true,
                    onFieldSubmitted: (_) => _login(scaffoldContext),
                  ),
                  RippleButton(
                    text: "เข้าสู่ระบบ",
                    backgroundColor: Theme.of(context).accentColor,
                    textColor: Colors.black,
                    highlightColor: Colors.grey.shade200,
                    onPress: () => _login(scaffoldContext),
                  ),
                  RippleButton(
                    text: "สมัครสมาชิก",
                    backgroundColor: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).accentColor,
                    highlightColor: Colors.grey.shade800,
                    onPress: _showRegister,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return LoadingContent(
      text: 'กำลังเข้าสู่ระบบ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Builder(builder: (BuildContext scaffoldContext) {
          return LoadingView(
            loadingStatus: widget.loginState.loadingStatus,
            initialContent: _buildInitialContent(scaffoldContext),
            loadingContent: _buildLoadingContent(),
          );
        }),
      ),
    );
  }
}
