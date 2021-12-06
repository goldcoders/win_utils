import 'dart:io';

class Example {
  Future<void> _injectPath({required Function(bool installed) onDone}) async {
    final String envpath = PathEnv.get();
    if (Platform.isWindows) {
      // Enable powershell script execution
      await Process.run('powershell', <String>[
        'Set-ExecutionPolicy',
        '-ExecutionPolicy',
        'Unrestricted',
        '-Scope',
        'CurrentUser'
      ]);
      Process.run(
        'powershell',
        <String>[
          '-command',
          '[Environment]::GetEnvironmentVariable("PATH", "User")',
        ],
        runInShell: true,
        workingDirectory: PC.userDirectory,
      ).asStream().listen((ProcessResult process) async {
        if (process.stdout is String) {
          Process.run(
            'powershell',
            <String>[
              '-command',
              '''
[Environment]::SetEnvironmentVariable("PATH", "${process.stdout.toString().trim()};$envpath","User")
''',
            ],
            runInShell: true,
            workingDirectory: PC.userDirectory,
          ).asStream().listen((ProcessResult process) async {
            // Refresh ENV
            await Process.run('powershell', <String>[
              // ignore: lines_longer_than_80_chars
              r'$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'
            ]);
            await _installOnWindows(onDone: onDone);
          });
        }
      });
    }
  }
}
