import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../../../../../../core/extensions/localization_extension.dart';
import '../../../../../../core/themes/app_colors/app_colors.dart';

class GenderSelectionWidget extends StatelessWidget {
  const GenderSelectionWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.genderTitle,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        RadioGroup<String>(
          groupValue: selectedGender,
          onChanged: (val) {
            if (val != null) {
              onGenderChanged(val);
            }
          },
          child: Row(
            children: [
              _buildRadioOption(
                context: context,
                value: 'Female',
                label: context.l10n.female,
              ),
              SizedBox(width: 24.w),
              _buildRadioOption(
                context: context,
                value: 'Male',
                label: context.l10n.male,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required BuildContext context,
    required String value,
    required String label,
  }) {
    final isSelected = selectedGender.toLowerCase() == value.toLowerCase();

    return InkWell(
      onTap: () => onGenderChanged(value),
      borderRadius: BorderRadius.circular(8.r),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 48.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: value,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
