// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:dio/dio.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
//
// // void main() => runApp(AudioRecorderApp());
//
// class AudioRecorderApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: AudioRecorderPage(),
//     );
//   }
// }
//
// class AudioRecorderPage extends StatefulWidget {
//   @override
//   _AudioRecorderPageState createState() => _AudioRecorderPageState();
// }
//
// class _AudioRecorderPageState extends State<AudioRecorderPage> {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   bool _isRecording = false;
//   bool _isPlaying = false;
//   String? _recordedFilePath;
//   List<String> _uploadedFiles = [];
//   final String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dqcdrgblc/auto/upload";
//   final String fetchUrl = "https://api.cloudinary.com/v1_1/dqcdrgblc/resources/audio";
//
//   @override
//   void initState() {
//     super.initState();
//     _initRecorder();
//     _player.openPlayer();
//     _fetchUploadedRecordings();
//   }
//
//   Future<void> _initRecorder() async {
//     await Permission.microphone.request();
//     await _recorder.openRecorder();
//   }
//
//   Future<void> _startOrStopRecording() async {
//     if (_isRecording) {
//       final filePath = await _recorder.stopRecorder();
//       print(filePath);
//       setState(() {
//         _isRecording = false;
//         _recordedFilePath = filePath;
//         _convertToMp3();
//       });
//     } else {
//       await _recorder.startRecorder(toFile: 'audio_record.aac');
//       setState(() => _isRecording = true);
//     }
//   }
//   // Future<void> _convertToMp3() async {
//   //   if (_recordedFilePath == null) return;
//   //   String outputPath = _recordedFilePath!.replaceAll('.aac', '.mp3');
//   //
//   //   // Execute FFmpeg command using ffmpeg_kit_flutter
//   //   FFmpegKit.execute('-i $_recordedFilePath -codec:a libmp3lame $outputPath').then((session) async {
//   //     final returnCode = await session.getReturnCode();
//   //     print('Recorded file path: $_recordedFilePath');
//   //     print('Output path: $outputPath');
//   //         _recordedFilePath = outputPath;
//   //
//   //     if (returnCode!.isValueSuccess()) {
//   //       setState(() {
//   //         _recordedFilePath = outputPath;
//   //         print('Conversion successful: $_recordedFilePath');
//   //       });
//   //     } else {
//   //       print('Error in conversion');
//   //     }
//   //   });
//   // }
//   Future<void> _convertToMp3() async {
//     if (_recordedFilePath == null) return;
//     Directory tempDir = await getTemporaryDirectory();
//     String outputPath = '${tempDir.path}/audio_record.mp3';
//
//     print('Recorded file path: $_recordedFilePath');
//     print('Output path: $outputPath');
//
//     FFmpegKit.execute('-i $_recordedFilePath -codec:a libmp3lame $outputPath')
//         .then((session) async {
//       final returnCode = await session.getReturnCode();
//       if (returnCode!.isValueSuccess()) {
//         setState(() {
//           _recordedFilePath = outputPath;
//           print('Conversion successful: $_recordedFilePath');
//         });
//       } else {
//         print('Error in conversion: ${await session.getLogs()}');
//       }
//     });
//   }
//
//   Future<void> _uploadRecording() async {
//     if (_recordedFilePath == null) return;
//     try {
//       FormData formData = FormData.fromMap({
//         "file": await MultipartFile.fromFile(_recordedFilePath!),
//         "upload_preset": "upload",
//       });
//       Response response = await Dio().post(cloudinaryUrl, data: formData);
//       if (response.statusCode == 200) {
//         setState(() {
//           _uploadedFiles.add(response.data['secure_url']);
//         });
//       }
//     } catch (e) {
//       print("Upload error: $e");
//     }
//   }
//
//   Future<void> _fetchUploadedRecordings() async {
//     try {
//       Response response = await Dio().get(fetchUrl, queryParameters: {
//         "api_key": 372198968472272,
//         "api_secret": "8g8I3CrEN3Ch2UBGDt8M907ekeo",
//       });
//       if (response.statusCode == 200) {
//         setState(() {
//           _uploadedFiles = List<String>.from(response.data['resources'].map((item) => item['secure_url']));
//         });
//       }
//     } catch (e) {
//       print("Fetch error: $e");
//     }
//   }
//
//   Future<void> _playOrStop(String url) async {
//     if (_isPlaying) {
//       await _player.stopPlayer();
//       setState(() => _isPlaying = false);
//     } else {
//       await _player.startPlayer(fromURI: url, codec: Codec.aacADTS);
//       setState(() => _isPlaying = true);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Audio Recorder')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: _startOrStopRecording,
//               child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _uploadRecording,
//               child: Text('Upload Recording'),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _uploadedFiles.length,
//                 itemBuilder: (context, index) {
//                   final url = _uploadedFiles[index];
//                   return ListTile(
//                     title: Text('Recording ${index + 1}'),
//                     trailing: IconButton(
//                       icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
//                       onPressed: () => _playOrStop(url),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _recorder.closeRecorder();
//     _player.closePlayer();
//     super.dispose();
//   }
// }
