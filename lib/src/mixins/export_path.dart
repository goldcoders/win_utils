/// Can be Exported Globally Since we will be needing this on Other Classes
mixin ExportPath {
  String _prependPathOnUnix(String paths) {
    return r'export PATH="' + paths + r':$HOME"';
  }

  String _appendPathOnUnix(String paths) {
    return r'export PATH="$HOME:' + paths + r'"';
  }

  String _prependPathOnWindows(String paths) {
    return r'$env:Path = "' + paths + r';$env:Path"';
  }

  String _appendPathOnWindows(String paths) {
    return r'$env:Path = "$env:Path;' + paths + r'"';
  }

  /// Returns The String to be used in the `.profile` `[unix]` or `$profile` `[windows]` file to set the PATH
  String appendPath(String paths, [String? platform = 'unix']) {
    if (platform == 'windows') {
      return _appendPathOnWindows(paths);
    } else {
      return _appendPathOnUnix(paths);
    }
  }

  /// Returns The String to be used in the `.profile` `[unix]` or `$profile` `[windows]` file to set the PATH
  String prependPath(String paths, [String? platform = 'unix']) {
    if (platform == 'windows') {
      return _prependPathOnWindows(paths);
    } else {
      return _prependPathOnUnix(paths);
    }
  }
}
