import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';

class LocalAndWebObjectsWidget extends StatefulWidget {
  final String orderId; // Tambahkan parameter orderId
  LocalAndWebObjectsWidget({Key? key, required this.orderId}) : super(key: key);

  @override
  _LocalAndWebObjectsWidgetState createState() =>
      _LocalAndWebObjectsWidgetState();
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');
  late String orderId; // Tambahkan variabel instance orderId
  bool isLoading = false; // Menyimpan status loading
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  void initState() {
    super.initState();
    orderId = widget
        .orderId; // Simpan nilai orderId dari widget sebagai variabel instance
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Object Transformation Gestures'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onRemoveEverything,
                  child: Text("Remove Everything"),
                ),
              ],
            ),
          ),
          if (isLoading) // Menampilkan AlertDialog saat isLoading true
            AlertDialog(
              title: Text('Sedang Mengunduh'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  CircularProgressIndicator(), // Menampilkan CircularProgress
                  // SizedBox(height: 10),
                  // Text('Resource sedang diunduh, mohon tunggu sebentar.'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: true,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;
  }

  Future<void> onRemoveEverything() async {
    anchors.forEach((anchor) {
      this.arAnchorManager!.removeAnchor(anchor);
    });
    anchors = [];
  }

  Future<String?> _getDesignURI(String orderId) async {
    try {
      final orderQuerySnapshot = await ordersCollection
          .where('orderId', isEqualTo: widget.orderId)
          .limit(1)
          .get();
      if (orderQuerySnapshot.docs.isNotEmpty) {
        final data = orderQuerySnapshot.docs.first;
        if (data != null) {
          return data[
              'hasilDesain3d']; // Ganti 'hasilDesain3d' sesuai dengan nama field di Firestore
        }
      }
    } catch (e) {
      print('Error retrieving design URI: $e');
    }
    return null;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(
        milliseconds: 500)); // Menunggu 0.5 detik untuk menampilkan loading

    ARHitTestResult? singleHitTestResult;
    try {
      singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane,
      );
    } catch (e) {
      // Jika tidak ditemukan hitTestResult, singleHitTestResult akan bernilai null
      singleHitTestResult = null;
    }

    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);

        // Get design URI based on orderId
        final orderId = widget.orderId; // Ganti dengan orderId yang sesuai
        final designURI = await _getDesignURI(orderId);
        if (designURI != null) {
          // Add node using designURI
          var newNode = ARNode(
            type: NodeType.webGLB,
            uri: designURI,
            scale: Vector3(1.5, 1.5, 1.5), // Ganti nilai scale sesuai kebutuhan
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0),
          );
          bool? didAddNodeToAnchor = await this
              .arObjectManager!
              .addNode(newNode, planeAnchor: newAnchor);

          if (didAddNodeToAnchor!) {
            this.nodes.add(newNode);
          } else {
            this.arSessionManager!.onError("Adding Node to Anchor failed");
          }
        } else {
          print('Failed to get design URI for orderId: $orderId');
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  onPanStarted(String nodeName) {
    print("Started panning node " + nodeName);
  }

  onPanChanged(String nodeName) {
    print("Continued panning node " + nodeName);
  }

  onPanEnded(String nodeName, Matrix4 newTransform) {
    print("Ended panning node " + nodeName);
    final pannedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }

  onRotationStarted(String nodeName) {
    print("Started rotating node " + nodeName);
  }

  onRotationChanged(String nodeName) {
    print("Continued rotating node " + nodeName);
  }

  onRotationEnded(String nodeName, Matrix4 newTransform) {
    print("Ended rotating node " + nodeName);
    final rotatedNode =
        this.nodes.firstWhere((element) => element.name == nodeName);
  }
}
