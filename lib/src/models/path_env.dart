import 'dart:io';

import 'package:win_utils/src/models/env_entity.dart';
import 'dart:developer' as devlog;

/// Can Be used to set the environment variables for the current process.
///
/// ```
/// Process.start(command,
/// args,
/// environment: <String,String>{
///   'PATH': PathEnv(paths,platform).toString()
/// },
/// runInShell: Platform.isWindows,
/// );
/// ```
/// We can also Set `[Platform.environment]` PATH using this class.
class PathEnv extends EnvEntity {
  const PathEnv({required List<String> paths, required String platform})
      : super(paths: paths, platform: platform);

  @override
  String toString() {
    RegExp pattern = RegExp(r'\n+');
    String text = paths.map((String e) => '$e\n').join();
    return text.replaceAll(pattern, _separator(platform));
  }

  String _separator(platform) {
    switch (platform) {
      case 'windows':
        return ';';
      default:
        return ':';
    }
  }

  Future<List<String>> _getUserPATH() async {
    List<String> userPaths = <String>[];
    if (platform == 'windows') {
      //! Only Get Here The Path
      ProcessResult result = await Process.run('powershell', <String>[
        r'''
[System.Environment]::GetEnvironmentVariable("PATH","User")'''
      ]);
      // loop
      result.stdout.split(_separator(platform)).forEach((String e) {
        if (e.isNotEmpty) {
          userPaths.add(e);
        }
      });
      devlog.inspect(userPaths);
    } else {
      ProcessResult result = await Process.run('echo', <String>['\$PATH']);
      result.stdout.split(_separator(platform)).forEach((String e) {
        if (e.isNotEmpty) {
          userPaths.add(e);
        }
      });
    }
    return userPaths;
  }

  Future<List<String>> _mergePaths() async {
    List<String> paths1 = await _getUserPATH();
    List<String> paths2 = paths;
    return paths1.toSet().union(paths2.toSet()).toList();
  }

  Future<String> getPath() async {
    RegExp pattern = RegExp(r'\n+');
    List<String> mergePaths = await _mergePaths();
    String paths = mergePaths.map((String e) => '$e\n').join();
    return paths.replaceAll(pattern, _separator(platform));
  }
  //? We need to move the logic to a updatePath Class

  //! Set Path on Windows using this but the [System.Environment] ...
  //! will be replaced by getPath()

  //! On Linux and Mac We Need to Override PATH by using getPath()
  //! we need to add that to either .bashrc , .zshrc
  //! or .profile or .zprofile

  // ProcessResult result = await Process.run('powershell', <String>[
  // r'''
// $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User")'''
  // ]);

}
