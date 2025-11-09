import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/ui/custom/animations/loading_containers.dart';
import '../../../../core/ui/custom/buttons/my_icon_button.dart';
import '../../../../core/ui/custom/icons/my_icons.dart';
import '../../../../core/utils/extensions.dart';

class RecipeDetailPageSkeleton extends StatelessWidget {
  const RecipeDetailPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: PrimaryLoadingContainer(
              height: MediaQuery.sizeOf(context).height * 0.3 + 25,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                color: context.background,
              ),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              PrimaryLoadingContainer(width: 140, height: 20),
                              Row(
                                spacing: 8,
                                children: [
                                  PrimaryLoadingContainer(
                                    width: 40,
                                    height: 12,
                                  ),
                                  PrimaryLoadingContainer(
                                    width: 110,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SecondaryLoadingContainer(
                          padding: EdgeInsets.all(8),
                          radius: 40,
                          child: PrimaryLoadingContainer(width: 14, height: 14),
                        ),
                      ],
                    ),
                    const Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: SecondaryLoadingContainer(
                            padding: EdgeInsets.all(16),
                            width: double.infinity,
                            radius: 40,
                            child: Row(
                              spacing: 12,
                              children: [
                                PrimaryLoadingContainer(width: 14, height: 14),
                                Expanded(
                                  flex: 3,
                                  child: PrimaryLoadingContainer(
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                                Expanded(child: SizedBox()),

                                PrimaryLoadingContainer(width: 14, height: 14),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const PrimaryLoadingContainer(width: 140, height: 12),
                    const Row(
                      spacing: 16,
                      children: [
                        Expanded(child: PrimaryLoadingContainer(height: 40)),
                        Expanded(child: PrimaryLoadingContainer(height: 40)),
                        Expanded(child: PrimaryLoadingContainer(height: 40)),
                        Expanded(child: PrimaryLoadingContainer(height: 40)),
                      ],
                    ),
                    SecondaryLoadingContainer(
                      padding: const EdgeInsets.all(20),
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      width: double.infinity,
                      radius: 24,
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: PrimaryLoadingContainer(height: 14),
                              ),
                              Expanded(child: SizedBox()),
                              Expanded(
                                flex: 2,
                                child: PrimaryLoadingContainer(height: 14),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => const Row(
                                spacing: 8,
                                children: [
                                  PrimaryLoadingContainer(
                                    height: 18,
                                    width: 18,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: PrimaryLoadingContainer(height: 14),
                                  ),
                                  Expanded(flex: 2, child: SizedBox()),
                                  PrimaryLoadingContainer(
                                    height: 14,
                                    width: 28,
                                  ),
                                ],
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemCount: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: true,
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    MyIconButton(
                      icon: MyIcons.chevron_left,
                      onTap: () {
                        context.pop();
                      },
                    ),
                    const SecondaryLoadingContainer(
                      padding: EdgeInsets.all(8),
                      radius: 40,
                      child: PrimaryLoadingContainer(width: 14, height: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
