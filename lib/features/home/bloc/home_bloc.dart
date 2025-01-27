import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_demo02/data/cartItems.dart';
import 'package:bloc_demo02/data/groceryData.dart';
import 'package:bloc_demo02/data/wishlistItems.dart';
import 'package:meta/meta.dart';

import '../models/homeProductDetails.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeProductWishListButtonClickedEvent>(
      (homeProductWishListButtonClickedEvent),
    );
    on<HomeProductCartButtonClickedEvent>(
      (homeProductCartButtonClickedEvent),
    );
    on<HomeWishListButtonNavigateEvent>(
      (homeWishListButtonNavigateEvent),
    );
    on<HomeCartButtonNavigateEvent>(
      (homeCartButtonNavigateEvent),
    );
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    emit(
      HomeLoadedSuccessState(
        products: GroceryData.groceryProducts
            .map(
              (e) => ProductDataModel(
                id: e['id'],
                name: e['name'],
                description: e['description'],
                price: e['price'],
                imageURL: e['imageUrl'],
              ),
            )
            .toList(),
      ),
    );
  }

  FutureOr<void> homeProductWishListButtonClickedEvent(
      HomeProductWishListButtonClickedEvent event, Emitter<HomeState> emit) {
    print("WishList Product Clicked");
    wishlistItems.add(event.clickedProduct);
    emit(HomeProductItemWishListedActionState());
  }

  FutureOr<void> homeProductCartButtonClickedEvent(
      HomeProductCartButtonClickedEvent event, Emitter<HomeState> emit) {
    print("Cart Product Clicked");
    cartItems.add(event.clickedProduct);
    emit(HomeProductItemCartedActionState());
    emit(HomeLoadedSuccessState(
      products: GroceryData.groceryProducts
          .map(
            (e) => ProductDataModel(
              id: e['id'],
              name: e['name'],
              description: e['description'],
              price: e['price'],
              imageURL: e['imageUrl'],
            ),
          )
          .toList(),
    ));
  }

  FutureOr<void> homeWishListButtonNavigateEvent(
      HomeWishListButtonNavigateEvent event, Emitter<HomeState> emit) {
    print("WishList Navigate Clicked");
    emit(HomeNavigateToWishlistPageActionState());
  }

  FutureOr<void> homeCartButtonNavigateEvent(
      HomeCartButtonNavigateEvent event, Emitter<HomeState> emit) {
    print("Cart Navigate Clicked");
    emit(HomeNavigateToCartPageActionState());
  }
}
