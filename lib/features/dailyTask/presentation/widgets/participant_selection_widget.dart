// import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
// import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
// import 'package:bluedock/common/widgets/text/text_widget.dart';
// import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
// import 'package:bluedock/core/config/theme/app_colors.dart';
// import 'package:bluedock/features/project/data/models/project/project_form_req.dart';
// import 'package:bluedock/features/project/presentation/bloc/project/project_form_cubit.dart';
// import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_cubit.dart';
// import 'package:bluedock/features/project/presentation/bloc/selection/project_selection_display_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class ParticipantSelectionWidget extends StatelessWidget {
//   final String title;
//   final List<StaffSelectionEntity> selected;
//   final void Function(StaffSelectionEntity) onPressed; // toggle: add/remove
//   final PhosphorIconData? icon;
//   final double heightButton;

//   const ParticipantSelectionWidget({
//     super.key,
//     required this.title,
//     required this.selected,
//     required this.onPressed,
//     this.icon,
//     this.heightButton = 50,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FormField<String>(
//       validator: (_) => selected.isEmpty ? '$title is required.' : null,
//       builder: (field) {
//         final hasError = field.hasError;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.w500),
//             SizedBox(height: 12),
//             GestureDetector(
//               onTap: () {
//                 BottomModalWidget.display(
//                   context,
//                   height: MediaQuery.of(context).size.height,
//                   MultiBlocProvider(
//                     providers: [
//                       BlocProvider.value(
//                         value: context.read<ProjectFormCubit>(),
//                       ),
//                       BlocProvider.value(
//                         value: context.read<ProjectSelectionDisplayCubit>()
//                           ..displayStaffSelection(''),
//                       ),
//                     ],
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextWidget(
//                             text: 'Choose $title:',
//                             fontWeight: FontWeight.w700,
//                             fontSize: 18,
//                           ),
//                           const SizedBox(height: 24),
//                           TextfieldWidget(
//                             prefixIcon: PhosphorIconsBold.magnifyingGlass,
//                             borderRadius: 60,
//                             iconColor: AppColors.darkBlue,
//                             hintText: 'Search',
//                             onChanged: (value) {
//                               context
//                                   .read<ProjectSelectionDisplayCubit>()
//                                   .displayStaffSelection(value);
//                             },
//                           ),
//                           const SizedBox(height: 24),
//                           Expanded(
//                             child:
//                                 BlocBuilder<
//                                   ProjectSelectionDisplayCubit,
//                                   ProjectSelectionDisplayState
//                                 >(
//                                   builder: (context, state) {
//                                     if (state
//                                         is ProjectSelectionDisplayLoading) {
//                                       return const Center(
//                                         child: CircularProgressIndicator(),
//                                       );
//                                     }
//                                     if (state
//                                         is ProjectSelectionDisplayFailure) {
//                                       return Center(child: Text(state.message));
//                                     }
//                                     if (state is StaffSelectionDisplayFetched) {
//                                       final listSelection = state.listSelection;
//                                       if (listSelection.isEmpty) {
//                                         return const Center(
//                                           child: Text('No staff found'),
//                                         );
//                                       }
//                                       return BlocBuilder<
//                                         ProjectFormCubit,
//                                         ProjectFormReq
//                                       >(
//                                         builder: (context, formState) {
//                                           final current = formState.listTeam;

//                                           bool containsId(String id) => current
//                                               .any((e) => e.staffId == id);

//                                           return ListView.separated(
//                                             padding: const EdgeInsets.only(
//                                               bottom: 3,
//                                             ),
//                                             itemCount: listSelection.length,
//                                             separatorBuilder: (_, __) =>
//                                                 const SizedBox(height: 16),
//                                             itemBuilder: (context, index) {
//                                               final value =
//                                                   listSelection[index];
//                                               final isSelected = containsId(
//                                                 value.staffId,
//                                               );

//                                               return ButtonWidget(
//                                                 height: 90,
//                                                 background: isSelected
//                                                     ? AppColors.blue
//                                                     : AppColors.white,
//                                                 title: value.fullName,
//                                                 content: Padding(
//                                                   padding: EdgeInsets.symmetric(
//                                                     horizontal: 12,
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       CircleAvatar(
//                                                         radius: 35,
//                                                         backgroundImage:
//                                                             NetworkImage(
//                                                               value.image,
//                                                             ),
//                                                       ),
//                                                       const SizedBox(width: 24),
//                                                       Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           TextWidget(
//                                                             text:
//                                                                 value.fullName,
//                                                             color: isSelected
//                                                                 ? AppColors
//                                                                       .white
//                                                                 : AppColors
//                                                                       .darkBlue,
//                                                             fontSize: 16,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                           SizedBox(height: 8),
//                                                           TextWidget(
//                                                             text: value
//                                                                 .role
//                                                                 .title,
//                                                             color: isSelected
//                                                                 ? AppColors
//                                                                       .white
//                                                                 : AppColors
//                                                                       .blue,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             fontSize: 14,
//                                                           ),
//                                                           SizedBox(height: 8),
//                                                           TextWidget(
//                                                             text: value
//                                                                 .phoneNumber,
//                                                             color: isSelected
//                                                                 ? AppColors
//                                                                       .white
//                                                                 : AppColors
//                                                                       .darkBlue,
//                                                             fontSize: 14,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 onPressed: () {
//                                                   onPressed(value);
//                                                   field.didChange('changed');
//                                                 },
//                                               );
//                                             },
//                                           );
//                                         },
//                                       );
//                                     }
//                                     return const SizedBox.shrink();
//                                   },
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               child: Material(
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     border: Border.all(
//                       width: 1.5,
//                       color: hasError ? AppColors.blue : AppColors.border,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: selected.isEmpty
//                             ? TextWidget(
//                                 text: title,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                                 color: AppColors.darkBlue,
//                               )
//                             : Wrap(
//                                 spacing: 8,
//                                 runSpacing: 8,
//                                 children: selected.map((s) {
//                                   return Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColors.blue,
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         TextWidget(
//                                           text: s.fullName,
//                                           color: AppColors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                       ),
//                       PhosphorIcon(
//                         icon ?? PhosphorIconsBold.caretDown,
//                         color: AppColors.blue,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             if (hasError) const SizedBox(height: 8),
//             if (hasError)
//               Padding(
//                 padding: const EdgeInsets.only(left: 4),
//                 child: Text(
//                   field.errorText ?? '$title is required.',
//                   style: TextStyle(color: AppColors.blue, fontSize: 12),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
