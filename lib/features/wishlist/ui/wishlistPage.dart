import 'package:bloc_demo02/data/wishlistItems.dart';
import 'package:bloc_demo02/features/wishlist/bloc/wishlist_bloc.dart';
import 'package:bloc_demo02/features/wishlist/ui/wishlistTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  final WishlistBloc wishlistBloc = WishlistBloc();

  @override
  void initState() {
    wishlistBloc.add(WishlistInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('WishList Items'),
      ),
      body: BlocConsumer<WishlistBloc, WishlistState>(
        bloc: wishlistBloc,
        listener: (context, state) {},
        listenWhen: (previous, current) => current is WishlistActionState,
        buildWhen: (previous, current) => current is! WishlistActionState,
        builder: (context, state) {
          switch (state.runtimeType) {
            case WishlistSuccessState:
              final successState = state as WishlistSuccessState;
              return wishlistItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: successState.wishlistItems.length,
                      itemBuilder: (context, index) {
                        return WishListTile(
                          productDataModel: successState.wishlistItems[index],
                          wishlistBloc: wishlistBloc,
                        );
                      })
                  : const Center(
                      child: Text(
                        "No Items Found!",
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
