import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../../logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import '../screens/login_page.dart';

class HomePageAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: const Text('digital store'),
      actions: <Widget>[
        BlocBuilder<AppBarCubit, AppBarState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () =>
                    context.read<AppBarCubit>().changeSearchingState(),
                icon: state is AppBarSearching
                    ? const Icon(Icons.close,
                        color: Color.fromARGB(255, 232, 52, 16))
                    : const Icon(
                        Icons.search,
                        color: Color.fromARGB(252, 227, 181, 43),
                      ));
          },
        ),
        BlocBuilder<AppBarCubit, AppBarState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () => context
                    .read<AppBarCubit>()
                    .changeSelectingCategoriesState(),
                icon: state is AppBarSelectingCategories
                    ? const Icon(Icons.close,
                        color: Color.fromARGB(255, 232, 52, 16))
                    : const Icon(
                        Icons.apps,
                      ));
          },
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserUnauthenticated) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                loginTitle:
                                    'Log in or register to buy products',
                              )));
                },
                icon: const SizedBox(
                  width: 40,
                  height: 40,
                  child: ImageIcon(
                    AssetImage(
                      'assets/images/user_unauthenticated.png',
                    ),
                    size: 40,
                  ),
                ),
                iconSize: 40,
              );
            } else {
              return IconButton(
                onPressed: () {
                  //see user profile
                },
                icon: const SizedBox(
                  width: 40,
                  height: 40,
                  child: ImageIcon(
                    AssetImage(
                      'assets/images/user_authenticated.png',
                    ),
                    size: 40,
                  ),
                ),
                iconSize: 40,
              );
            }
          },
        )
      ],
    );
  }
}