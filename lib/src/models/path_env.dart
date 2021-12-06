import 'dart:developer' as devlog;

import 'package:win_utils/src/mixins/export_path.dart';
import 'package:win_utils/src/mixins/extract_path_env.dart';
import 'package:win_utils/src/models/env_entity.dart';

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
class PathEnv extends EnvEntity with ExtractPath, ExportPath {
  const PathEnv({required List<String> paths, required String platform})
      : super(paths: paths, platform: platform);

  @override

  /// Print the Application Paths That Will Be Used.
  ///
  /// Can be Used with Export Path Mixins to update `.profile` or `$profile`
  ///
  /// Or Set Environment Variables in Windows
  String toString() {
    RegExp pattern = RegExp(r'\n+');
    String text = paths.map((String e) => '$e\n').join();
    return text.replaceAll(pattern, separator(platform));
  }

  /// Returns Current Paths in Your System
  Future<List<String>> _getUserPATH() async {
    List<String> userPaths = <String>[];
    if (platform == 'windows') {
      userPaths.addAll(await getUserPathOnWindows());
      devlog.inspect(userPaths);
    } else {
      userPaths.addAll(await getPathOnOtherPlatform(platform));
    }
    return userPaths;
  }

  /// Merge application [paths] with System OS [_getUserPATH]
  Future<List<String>> _mergePaths() async {
    List<String> paths1 = await _getUserPATH();
    List<String> paths2 = paths;
    return paths1.toSet().union(paths2.toSet()).toList();
  }

  /// Returns All Paths in Your System
  ///
  /// Can Be Used with Export Path Mixins to Add it to your `.profile` or `$profile`
  ///
  /// Or To Set Environment Variables on Windows
  Future<String> all() async {
    RegExp pattern = RegExp(r'\n+');
    List<String> mergePaths = await _mergePaths();
    String paths = mergePaths.map((String e) => '$e\n').join();
    return paths.replaceAll(pattern, separator(platform));
  }

  Future<void> set() async {
    if (platform == 'windows') {
      throw UnimplementedError('Not Implemented');
      // setEnvOnWindows(toString());
    } else {
      throw UnimplementedError('Not Implemented');
      // setEnvOnOtherPlatform(toString());
    }
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
