import 'package:calender_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:calender_app/features/calendar/data/repositories/event_repository.dart';
import 'package:calender_app/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:calender_app/features/calendar/presentation/screens/add_event_screen.dart';
import 'package:calender_app/features/calendar/presentation/widgets/event_list_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:calender_app/app/app.dart';
import 'package:calender_app/core/constants/app_colors.dart';


class CalendarScreen extends StatelessWidget {
  final User user;
  const CalendarScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(
        eventRepository: EventRepository(),
        userId: user.uid,
      ),
      child: Scaffold(
        appBar: _AppBar(),
        body: Column(
          children: [
            _CalendarView(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24.0),
                    _SelectedDayHeader(),
                    const SizedBox(height: 16.0),
                    const EventListView(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<CalendarCubit>(context),
                      child: AddEventScreen(selectedDate: state.selectedDay),
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ).animate().scale(delay: 300.ms, duration: 400.ms);
          },
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            DateFormat.yMMMM().format(state.focusedDay),
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SelectedDayHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Text(
                '•',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(state.selectedDay),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return TableCalendar(
          firstDay: DateTime.utc(2010, 1, 1),
          lastDay: DateTime.utc(2040, 12, 31),
          focusedDay: state.focusedDay,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            context
                .read<CalendarCubit>()
                .onDaySelected(selectedDay, focusedDay);
          },
          onPageChanged: (focusedDay) {
            context.read<CalendarCubit>().onPageChanged(focusedDay);
          },
          calendarStyle: CalendarStyle(
            defaultTextStyle:
                const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
            weekendTextStyle:
                const TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
            outsideTextStyle:
                const TextStyle(color: AppColors.textFaded, fontWeight: FontWeight.w500),
            todayDecoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
            todayTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: AppColors.textFaded, fontWeight: FontWeight.bold),
            weekendStyle: TextStyle(color: AppColors.textFaded, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
} 