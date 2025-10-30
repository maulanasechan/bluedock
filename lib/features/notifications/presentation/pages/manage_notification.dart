import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/search_textfield_widget.dart';
import 'package:bluedock/core/config/theme/app_colors.dart';
import 'package:bluedock/features/notifications/presentation/bloc/notif_display_cubit.dart';
import 'package:bluedock/features/notifications/presentation/bloc/notif_display_state.dart';
import 'package:bluedock/features/notifications/presentation/widgets/notification_card_slideable_widget.dart';
import 'package:bluedock/features/project/presentation/widgets/project_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageNotificationPage extends StatelessWidget {
  const ManageNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotifDisplayCubit()..displayInitial(),
        ),
        BlocProvider(create: (context) => ActionButtonCubit()),
      ],
      child: GradientScaffoldWidget(
        hideBack: true,
        showBottomNavigation: true,
        currentIndex: 2,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 90, 0, 20),
          child: Column(
            children: [
              SizedBox(
                width: 250,
                child: TextWidget(
                  text: 'Notifications',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  align: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              BlocBuilder<NotifDisplayCubit, NotifDisplayState>(
                builder: (context, state) {
                  final type = context.read<NotifDisplayCubit>().currentType;
                  final selectedLabel = (type.isEmpty)
                      ? 'All'
                      : '${type[0].toUpperCase()}${type.substring(1)}';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchTextfieldWidget(
                        selectedColor: AppColors.blue,
                        withFilter: true,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            context.read<NotifDisplayCubit>().displayInitial();
                          } else {
                            context.read<NotifDisplayCubit>().setKeyword(value);
                          }
                        },
                        listFilter: const [
                          'All',
                          'Aftersales',
                          'Daily Task',
                          'Invoice',
                          'Project',
                          'Purchase Order',
                        ],
                        selected: selectedLabel,
                        onSelected: (value) {
                          final mapped = value == 'All' ? '' : value;
                          context.read<NotifDisplayCubit>().setType(mapped);
                        },
                      ),
                      SizedBox(height: selectedLabel != 'All' ? 24 : 12),
                      if (selectedLabel != 'All')
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextWidget(
                              text: 'Notification from:',
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(width: 6),
                            TextWidget(
                              text: selectedLabel,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
              SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<NotifDisplayCubit, NotifDisplayState>(
                  builder: (context, state) {
                    if (state is NotifDisplayLoading) {
                      return ProjectLoadingWidget();
                    }
                    if (state is NotifDisplayFetched) {
                      if (state.listNotif.isEmpty) {
                        return Center(
                          child: TextWidget(
                            text: "There isn't any notification.",
                          ),
                        );
                      } else {
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == state.listNotif.length - 1
                                    ? 40
                                    : 0,
                              ),
                              child: NotificationCardSlideableWidget(
                                notif: state.listNotif[index],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 12);
                          },
                          itemCount: state.listNotif.length,
                        );
                      }
                    }
                    return SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
