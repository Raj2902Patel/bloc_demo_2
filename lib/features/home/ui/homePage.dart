import 'package:bloc_demo02/features/cart/ui/cartPage.dart';
import 'package:bloc_demo02/features/home/bloc/home_bloc.dart';
import 'package:bloc_demo02/features/home/ui/productTile.dart';
import 'package:bloc_demo02/features/wishlist/ui/wishlistPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc homeBloc = HomeBloc();

  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Cart(),
            ),
          );
        } else if (state is HomeNavigateToWishlistPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WishListPage(),
            ),
          );
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text("The Item Has Been Added To Your Cart!"),
              ),
            ),
          );
        } else if (state is HomeProductItemWishListedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text("The Item Has Been Added To Wish List!"),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                toolbarHeight: 65,
                backgroundColor: Colors.teal.withOpacity(0.3),
                title: const Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text("HomePage"),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            homeBloc.add(HomeWishListButtonNavigateEvent());
                          },
                          icon: const Icon(Icons.favorite_border),
                        ),
                        IconButton(
                          onPressed: () {
                            homeBloc.add(HomeCartButtonNavigateEvent());
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: successState.products.length,
                itemBuilder: (context, index) {
                  return ProductTileWidget(
                    productDataModel: successState.products[index],
                    homeBloc: homeBloc,
                  );
                },
              ),
            );

          case HomeErrorState:
            return const Scaffold(
              body: Center(
                child: Text("Error!"),
              ),
            );
          default:
            return const Scaffold(
              body: SizedBox(),
            );
        }
      },
    );
  }
}
