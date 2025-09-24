import 'package:bluedock/common/widgets/button/widgets/button_widget.dart';
import 'package:bluedock/common/widgets/dropdown/widgets/dropdown_widget.dart';
import 'package:bluedock/common/widgets/gradientScaffold/gradient_scaffold_widget.dart';
import 'package:bluedock/common/widgets/textfield/blocs/password_textfield_cubit.dart';
import 'package:bluedock/common/widgets/textfield/validator/app_validator.dart';
import 'package:bluedock/common/widgets/textfield/widgets/password_textfield_widget.dart';
import 'package:bluedock/common/widgets/textfield/widgets/textfield_widget.dart';
import 'package:bluedock/core/config/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddOrUpdateStaffPage extends StatelessWidget {
  const AddOrUpdateStaffPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => PasswordTextfieldCubit())],
      child: GradientScaffoldWidget(
        hideBack: false,
        appbarTitle: 'Add New Staff',
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextfieldWidget(
                validator: AppValidators.fullName(),
                hintText: 'Fullname',
                title: 'Fullname',
                suffixIcon: PhosphorIconsBold.identificationCard,
              ),
              SizedBox(height: 24),
              TextfieldWidget(
                validator: AppValidators.nik(),
                hintText: 'NIK',
                title: 'NIK',
                suffixIcon: PhosphorIconsBold.creditCard,
              ),
              SizedBox(height: 24),
              TextfieldWidget(
                validator: AppValidators.email(),
                hintText: 'Email',
                title: 'Email',
                suffixIcon: PhosphorIconsFill.envelopeSimple,
              ),
              SizedBox(height: 24),
              PasswordTextfieldWidget(title: 'Password'),
              SizedBox(height: 24),
              TextfieldWidget(
                validator: AppValidators.address(),
                hintText: 'Address',
                title: 'Address',
                maxLines: 4,
              ),
              SizedBox(height: 24),
              DropdownWidget(title: 'Role'),
              SizedBox(height: 50),
              ButtonWidget(
                onPressed: () {
                  context.goNamed(
                    AppRoutes.successStaff,
                    extra: 'New user had been created',
                  );
                },
                title: 'Add New Staff',
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
