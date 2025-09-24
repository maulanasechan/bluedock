import 'package:bluedock/common/widgets/text/text_widget.dart';
import 'package:bluedock/features/home/data/models/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenuListWidget extends StatelessWidget {
  final List<MenuModel> listMenu;

  const MenuListWidget({super.key, required this.listMenu});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listMenu.length,
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (BuildContext context, int index) {
        final menu = listMenu[index];
        return GestureDetector(
          onTap: () {
            context.pushNamed(menu.route);
          },
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.asset(menu.icon, fit: BoxFit.contain),
              ),
              const SizedBox(height: 10),
              TextWidget(
                text: menu.title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.visible,
                maxLines: 2,
                align: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
