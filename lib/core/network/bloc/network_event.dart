import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}

class NetworkStatusChanged extends NetworkEvent {
  final List<ConnectivityResult> results;

  const NetworkStatusChanged(this.results);

  @override
  List<Object?> get props => [results];
}
