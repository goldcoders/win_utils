import 'dart:io';

mixin PathSetter {
  static String _getUserDirectory() {
    switch (Platform.operatingSystem) {
      case 'linux':
      case 'macos':
        return Platform.environment['HOME']!;
      case 'windows':
        return Platform.environment['USERPROFILE']!;
      default:
        throw UnsupportedError('Unsupported operating system.');
    }
  }

  static String _getOwner(String? owner) {
    switch (owner?.toLowerCase()) {
      case 'machine':
        return 'Machine';
      default:
        return 'User';
    }
  }

  /// We will Passed here the PATH in String Format with proper separator
  /// Owner Can Either be Machine or User, Uses the default value of User
  void setPathOnWindows(String paths, [String? owner]) {
    Process.run(
      'powershell',
      <String>[
        '-command',
        '''
[Environment]::SetEnvironmentVariable("PATH", "$paths","${_getOwner(owner)}")
''',
      ],
      runInShell: true,
      workingDirectory: _getUserDirectory(),
    );
  }
  //Modify a system environment variable

  // [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)

  //Modify a user environment variable

  // [Environment]::SetEnvironmentVariable("INCLUDE", $env:INCLUDE, [System.EnvironmentVariableTarget]::User)

  // Usage:
  // [Environment]::SetEnvironmentVariable(
  // "Path",
  // [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine) + ";C:\bin",
  // [EnvironmentVariableTarget]::Machine)

  // String based solution is also possible if you don't want to write types
  //[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\bin", "Machine")
}
