import 'package:equatable/equatable.dart';

class EnvEntity extends Equatable {
  final List<String> paths;
  final String platform;

  const EnvEntity({
    required this.paths,
    required this.platform,
  });

  @override
  List<Object?> get props => <Object?>[paths, platform];
}
