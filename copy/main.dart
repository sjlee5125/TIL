import 'package:flutter/material.dart';
import 'dart:io'; // File
import 'dart:convert'; // jsonDecode
import 'package:image_picker/image_picker.dart'; // image_picker
import 'package:http/http.dart' as http; // http

// 데이터베이스 & 사진 저장소
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// [중요] 기록장 화면 불러오기
import 'history_screen.dart'; 

const String backendServerIp = "10.100.0.28";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 플러터 엔진 초기화
  await Firebase.initializeApp(); // Firebase 연결 시작
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '재활용 분리수거',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _analysisResult = "사진을 찍거나 선택해주세요.";
  List<String> _analysisMethodSteps = []; 
  bool _isLoading = false;

  // Firebase에 사진과 결과를 저장하는 함수
  Future<void> _saveToFirebase(File imageFile, Map<String, dynamic> aiResult) async {
    try {
      // 1. Storage에 사진 업로드 (파일명은 현재 시간)
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref().child('recycle_images/$fileName.jpg');
      await storageRef.putFile(imageFile);
      String imageUrl = await storageRef.getDownloadURL(); // 업로드된 주소 받기

      // 2. Firestore에 데이터 저장
      await FirebaseFirestore.instance.collection('history').add({
        'imageUrl': imageUrl,
        'aiResult': aiResult, 
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("✅ Firebase 저장 성공!");
    } catch (e) {
      print("❌ 저장 실패: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _analysisResult = "이미지가 선택되었습니다.";
          _analysisMethodSteps = ["분석 버튼을 눌러주세요."];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = "이미지 선택 실패";
        _analysisMethodSteps = [e.toString()];
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      setState(() {
        _analysisResult = "먼저 이미지를 선택해주세요.";
        _analysisMethodSteps = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = "서버에서 분석 중입니다...";
      _analysisMethodSteps = ["(약 3~5초 소요됩니다)"];
    });

    try {
      final uri = Uri.parse("http://$backendServerIp:5000/analyze");
      var request = http.MultipartRequest("POST", uri);
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);
      
      if (response.statusCode == 200) {
        setState(() {
          _analysisResult = data['result'];
          _analysisMethodSteps = List<String>.from(data['method']);
        });

        // 분석 성공 시 Firebase 저장 함수 실행
        if (_image != null) {
          _saveToFirebase(_image!, data);
        }

      } else {
        setState(() {
          _analysisResult = "서버 오류: ${response.statusCode}";
          _analysisMethodSteps = ["${data['result']} ${data['method']}"];
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = "전송 오류 (IP 확인)";
        _analysisMethodSteps = [e.toString()];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("스마트 분리수거 도우미"),
        // ▼▼▼ 여기에 기록장 버튼이 추가되었습니다 ▼▼▼
        actions: [
          IconButton(
            icon: const Icon(Icons.history), // 시계 아이콘
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),  
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _image == null
                        ? const Center(child: Text('이미지가 없습니다.'))
                        : Image.file(_image!, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text("갤러리"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("카메라"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    onPressed: _isLoading ? null : _analyzeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("이 이미지 분석하기"),
                  ),
                  const SizedBox(height: 30),
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "분석 결과",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 8.0),
                          child: Text(
                            _analysisResult,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        
                        if (_analysisMethodSteps.isNotEmpty && !_isLoading && _analysisMethodSteps[0] != "분석 버튼을 눌러주세요.")
                          const Divider(color: Colors.grey),
                          
                        if (_analysisMethodSteps.isNotEmpty && !_isLoading && _analysisMethodSteps[0] != "분석 버튼을 눌러주세요.")
                          const Text(
                            "처리 방법",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        
                        ..._analysisMethodSteps.map((step) {
                          if (_isLoading || step == "분석 버튼을 눌러주세요." || _analysisResult == "서버에서 분석 중입니다...") {
                             if (_isLoading || step == "분석 버튼을 눌러주세요."){
                               return Padding(
                                 padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                                 child: Text(step, style: const TextStyle(fontSize: 16)),
                               );
                             }
                             return Container();
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("• ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Expanded(child: Text(step, style: const TextStyle(fontSize: 16))),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
 
                  const SizedBox(height: 50), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}