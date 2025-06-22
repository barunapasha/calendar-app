import 'package:calender_app/core/constants/app_colors.dart';
import 'package:calender_app/features/auth/data/repositories/auth_repository.dart';
import 'package:calender_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:calender_app/features/auth/presentation/screens/login_screen.dart';
import 'package:calender_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calendar App',
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.primary,
            ),
            textTheme: GoogleFonts.plusJakartaSansTextTheme(
              Theme.of(context).textTheme,
            ).apply(bodyColor: AppColors.textDark),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: AppColors.textDark),
              titleTextStyle: TextStyle(
                color: AppColors.textDark,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const AuthWrapper(),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            return CalendarScreen(user: state.user!);
          case AuthStatus.unauthenticated:
            return const LoginScreen();
          case AuthStatus.unknown:
            return const Scaffold(
              backgroundColor: AppColors.darkBackground,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
        }
      },
    );
  }
} 