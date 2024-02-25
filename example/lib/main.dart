import 'dart:ffi';
import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:device_apps_example/apps_events.dart';
import 'package:device_apps_example/apps_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MaterialApp(home: const NewExampleApp()));

class ExampleApp extends StatelessWidget {
  ExampleApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Device apps demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) => AppsListScreen()),
                  );
                },
                child: Text('Applications list')),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Object>(
                        builder: (BuildContext context) => AppsEventsScreen()),
                  );
                },
                child: Text('Applications events'))
          ],
        ),
      ),
    );
  }
}

class NewExampleApp extends StatefulWidget {
  const NewExampleApp();

  @override
  State<NewExampleApp> createState() => _NewExampleAppState();
}

class _NewExampleAppState extends State<NewExampleApp> {
  Application? app;
  int? fileSize;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('demo')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  PermissionStatus storage = await Permission.manageExternalStorage.request();
                  if(storage!= PermissionStatus.granted){
                    return;
                  }
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if(result==null || result.files.isEmpty){
                    return;
                  }
                  if((result.files.single.path?.isEmpty??true)){
                    return;
                  }
                  fileSize = result.files.single.size;
                  app = await DeviceApps.getAppByApkFile(result.files.single.path!,true);
                  setState(() {
                  });
                },
                child: Text('selectAppFile')),
              app!=null ?ListTile(
                leading: app is ApplicationWithIcon
                    ? CircleAvatar(
                  backgroundImage: MemoryImage((app! as ApplicationWithIcon).icon),
                  backgroundColor: Colors.white,
                )
                    : null,
                title: Text('${app!.appName} (${app!.packageName})'),
                subtitle: Text('版本: ${app!.versionName}\n'
                    '文件大小: $fileSize')
              ) :Spacer()
          ],
        ),
      ),
    );
  }
}