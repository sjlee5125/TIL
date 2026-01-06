import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("나의 분리수거 기록"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        // Firebase 'history' 컬렉션을 실시간으로 감시합니다.
        stream: FirebaseFirestore.instance
            .collection('history')
            .orderBy('timestamp', descending: true) // 최신순 정렬
            .snapshots(),
        builder: (context, snapshot) {
          // 1. 데이터 가져오는 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. 데이터가 없을 때
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "아직 기록이 없습니다.\n사진을 찍어 분석해보세요!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 3. 데이터가 있을 때 (리스트로 보여주기)
          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              // 결과 텍스트 가져오기 (혹시 데이터가 깨져있을 경우 대비)
              String resultText = "분석 결과";
              try {
                 resultText = data['aiResult']['result'] ?? "결과 없음";
              } catch (e) {
                 resultText = "결과 불러오기 오류";
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // 왼쪽: 사진 미리보기
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['imageUrl'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  // 가운데: 분석 결과
                  title: Text(
                    resultText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // 아래: 날짜 표시
                  subtitle: Text(
                    (data['timestamp'] as Timestamp?)?.toDate().toString().split('.')[0] ?? "날짜 없음",
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}