import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkBloc(this._connectivity) : super(NetworkInitial()) {
    on<NetworkStatusChanged>((event, emit) {
      if (event.results.contains(ConnectivityResult.none) || event.results.isEmpty) {
        emit(NetworkDisconnected());
      } else {
        emit(NetworkConnected());
      }
    });

    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      add(NetworkStatusChanged(results));
    });
    
    // Initial check
    _connectivity.checkConnectivity().then((results) {
      add(NetworkStatusChanged(results));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
