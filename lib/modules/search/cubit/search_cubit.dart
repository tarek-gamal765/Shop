import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/components/constants.dart';
import 'package:shop/dio_helper/dio_helper.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/modules/search/cubit/search_states.dart';
import 'package:shop/network/remote/end_points.dart';

class ShopSearchCubit extends Cubit<ShopSearchStates> {
  ShopSearchCubit() : super(ShopSearchInitialState());

static ShopSearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  getShopSearchData({ String? text}) {
    emit(ShopSearchLoadingState());
    ShopDioHelper.postData(
      url: SEARCH,
      token: token,
      data: {
        'text': text ,
      },

      language: lang,
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(ShopSearchSuccessState());
    }).catchError((error) {
      emit(ShopSearchErrorState());
    });
  }
}
