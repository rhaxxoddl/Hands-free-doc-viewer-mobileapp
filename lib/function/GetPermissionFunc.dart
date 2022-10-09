import 'package:permission_handler/permission_handler.dart';

Future<bool> getPermission() async {
  Map<Permission, PermissionStatus> status = await [
    Permission.camera,
    Permission.storage
  ].request(); // [] 권한배열에 권한을 작성
  if (await Permission.camera.isGranted && await Permission.storage.isGranted) {
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}
