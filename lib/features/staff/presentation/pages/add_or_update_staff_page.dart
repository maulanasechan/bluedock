import 'package:bluedock/common/widgets/modal/bottom_modal_widget.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_cubit.dart';
import 'package:bluedock/common/widgets/button/bloc/action_button_state.dart';
import 'package:bluedock/common/widgets/button/widgets/action_button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/dropdown_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/helper/validator/validator_helper.dart';
import 'package:bluedock/common/widgets/textfield/widgets/password_textfield_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:bluedock/features/staff/data/models/staff_form_req.dart';
import 'package:bluedock/common/domain/entities/staff_entity.dart';
import 'package:bluedock/features/staff/domain/usecases/add_staff_usecase.dart';
import 'package:bluedock/features/staff/domain/usecases/update_staff_usecase.dart';
import 'package:bluedock/features/staff/presentation/bloc/staff_form_cubit.dart';
import 'package:bluedock/features/staff/presentation/bloc/role_display_cubit.dart';
import 'package:bluedock/features/staff/presentation/widgets/role_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddOrUpdateStaffPage extends StatelessWidget {
  final StaffEntity? staff;
  AddOrUpdateStaffPage({super.key, this.staff});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isUpdate = staff != null;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RoleDisplayCubit()),
        BlocProvider(create: (context) => PasswordTextfieldCubit()),
        BlocProvider(create: (context) => ActionButtonCubit()),
        BlocProvider(
          create: (_) {
            final c = StaffFormCubit();
            if (isUpdate) c.hydrateFromEntity(staff!);
            return c;
          },
        ),
      ],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: isUpdate ? 'Update Staff' : 'Add New Staff',
        body: BlocListener<ActionButtonCubit, ActionButtonState>(
          listener: (context, state) async {
            if (state is ActionButtonFailure) {
              var snackbar = SnackBar(content: Text(state.errorMessage));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ActionButtonSuccess) {
              final changed = await context.pushNamed(
                AppRoutes.successStaff,
                extra: {
                  'title': isUpdate
                      ? 'Staff has been updated'
                      : 'New staff has been added',
                },
              );
              if (changed == true && context.mounted) {
                context.pop(true);
              }
            }
          },
          child: SingleChildScrollView(
            child: BlocBuilder<StaffFormCubit, StaffFormReq>(
              builder: (context, state) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextfieldWidget(
                        validator: AppValidators.fullName(),
                        hintText: 'Fullname',
                        title: 'Fullname',
                        initialValue: state.fullName,
                        suffixIcon: PhosphorIconsBold.identificationCard,
                        onChanged: (v) =>
                            context.read<StaffFormCubit>().setFullName(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.nip(),
                        hintText: 'NIP',
                        title: 'NIP',
                        initialValue: state.nip,
                        suffixIcon: PhosphorIconsBold.cardholder,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (v) =>
                            context.read<StaffFormCubit>().setNIP(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.nik(),
                        hintText: 'NIK',
                        title: 'NIK',
                        initialValue: state.nik,
                        keyboardType: TextInputType.number,
                        suffixIcon: PhosphorIconsBold.creditCard,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        onChanged: (v) =>
                            context.read<StaffFormCubit>().setNIK(v),
                      ),
                      if (isUpdate != true) SizedBox(height: 24),
                      if (isUpdate != true)
                        TextfieldWidget(
                          validator: AppValidators.email(),
                          hintText: 'Email',
                          title: 'Email',
                          initialValue: state.email,
                          keyboardType: TextInputType.emailAddress,
                          suffixIcon: PhosphorIconsFill.envelopeSimple,
                          onChanged: (v) =>
                              context.read<StaffFormCubit>().setEmail(v),
                        ),
                      if (isUpdate != true) SizedBox(height: 24),
                      if (isUpdate != true)
                        PasswordTextfieldWidget(
                          title: 'Password',
                          initialValue: state.password,
                          onChanged: (v) =>
                              context.read<StaffFormCubit>().setPassword(v),
                        ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.address(),
                        hintText: 'Address',
                        title: 'Address',
                        initialValue: state.address,
                        maxLines: 4,
                        onChanged: (v) =>
                            context.read<StaffFormCubit>().setAddress(v),
                      ),
                      SizedBox(height: 24),
                      TextfieldWidget(
                        validator: AppValidators.number(),
                        hintText: 'Phone Number',
                        title: 'Phone Number',
                        initialValue: state.phoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(12),
                        ],
                        onChanged: (v) =>
                            context.read<StaffFormCubit>().setPhoneNumber(v),
                      ),
                      SizedBox(height: 24),
                      DropdownWidget(
                        title: 'Role',
                        state: state.role == null ? 'Role' : state.role!.title,
                        validator: (_) =>
                            state.role == null ? 'Role is required.' : null,
                        onTap: () {
                          BottomModalWidget.display(
                            context,
                            MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<StaffFormCubit>(),
                                ),
                                BlocProvider.value(
                                  value: context.read<RoleDisplayCubit>()
                                    ..displayRoles(),
                                ),
                              ],
                              child: RoleModalWidget(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 50),
                      ActionButtonWidget(
                        onPressed: () {
                          final isValid =
                              _formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          context.read<ActionButtonCubit>().execute(
                            usecase: isUpdate
                                ? UpdateStaffUseCase()
                                : AddStaffUseCase(),
                            params: context.read<StaffFormCubit>().state,
                          );
                        },
                        title: isUpdate ? 'Update Staff' : 'Add New Staff',
                        fontSize: 16,
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
