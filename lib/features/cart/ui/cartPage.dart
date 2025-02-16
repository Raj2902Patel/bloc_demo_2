import 'package:bloc_demo02/data/cartItems.dart';
import 'package:bloc_demo02/features/cart/bloc/cart_bloc.dart';
import 'package:bloc_demo02/features/cart/ui/cartTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartBloc cartBloc = CartBloc();
  @override
  void initState() {
    cartBloc.add(CartInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Cart Items'),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {},
        listenWhen: (previous, current) => current is CartActionState,
        buildWhen: (previous, current) => current is! CartActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case CartSuccessState:
              final successState = state as CartSuccessState;
              return cartItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: successState.cartItems.length,
                      itemBuilder: (context, index) {
                        return CartTile(
                            cartBloc: cartBloc,
                            productDataModel: successState.cartItems[index]);
                      },
                    )
                  : const Center(
                      child: Text(
                        "No Data Found!",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20.0,
                        ),
                      ),
                    );

            default:
          }
          return Container();
        },
      ),
    );
  }
}
