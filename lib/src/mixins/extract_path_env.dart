import 'dart:io';

mixin ExtractPath {
// ignore: unused_element
  String separator(String platform) {
    switch (platform) {
      case 'windows':
        return ';';
      default:
        return ':';
    }
  }

  Future<List<String>> getUserPathOnWindows() async {
    List<String> userPaths = <String>[];
    try {
      ProcessResult result = await Process.run('powershell', <String>[
        '-c',
        r'''
[System.Environment]::GetEnvironmentVariable("PATH","User")'''
      ]);
      result.stdout.split(separator('windows')).forEach((String e) {
        if (e.isNotEmpty) {
          userPaths.add(e);
        }
      });
    } catch (e, stackstrace) {
      throw ProcessException(
          r'powershell',
          [
            '-c',
            r'''
[System.Environment]::GetEnvironmentVariable("PATH","User")'''
          ],
          stackstrace.toString(),
          exitCode = 1);
    }
    return userPaths;
  }

  Future<List<String>> getPathOnOtherPlatform(String platform) async {
    List<String> userPaths = <String>[];
    try {
      ProcessResult result = await Process.run('echo', <String>['\$PATH']);
      result.stdout.split(separator('unix')).forEach((String e) {
        if (e.isNotEmpty) {
          userPaths.add(e);
        }
      });
    } catch (e, stackstrace) {
      throw ProcessException(
          'echo', <String>['\$PATH'], stackstrace.toString(), exitCode = 1);
    }
    return userPaths;
  }
}
