// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VideoPlayerScreen extends StatefulWidget {
//   final String url;

//   const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);

//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _controller;
//   bool isVideoAvailable = false;

//   @override
//   void initState() {
//     super.initState();
//     _checkVideoAvailability(widget.url);
//   }

//   // Function to check video availability by validating the URL
//   void _checkVideoAvailability(String url) async {
//     try {
//       final uri = Uri.parse(url);
//       final response = await launchUrl(uri, mode: LaunchMode.externalApplication);
//       if (response) {
//         setState(() {
//           isVideoAvailable = true; // Set to true if URL can be launched
//         });
//       }
//     } catch (e) {
//       setState(() {
//         isVideoAvailable = false; // Set to false if URL is not available
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lesson Video'),
//       ),
//       body: Center(
//         child: isVideoAvailable
//             ? _controller.value.isInitialized
//                 ? Container(
//                     width: 300,  // Set the width of the video container
//                     height: 200, // Set the height of the video container
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10), // Optional rounded corners
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: VideoPlayer(_controller), // Play video in this container
//                     ),
//                   )
//                 : const CircularProgressIndicator()
//             : GestureDetector(
//                 onTap: () {
//                   // Optionally, you can show a message or open an external browser if the video is invalid
//                 },
//                 child: Container(
//                   width: 300,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         spreadRadius: 1,
//                         blurRadius: 3,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 40,
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
// }
