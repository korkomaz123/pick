part of 'ciga_app_bloc.dart';

class CigaAppState extends Equatable {
  CigaAppState({this.cartItemCount});

  final int cartItemCount;

  CigaAppState init() {
    return CigaAppState(
      cartItemCount: 0,
    );
  }

  CigaAppState setCartCount(int cartItemCount) {
    return CigaAppState(
      cartItemCount: cartItemCount ?? this.cartItemCount,
    );
  }

  @override
  List<Object> get props => [cartItemCount];
}
