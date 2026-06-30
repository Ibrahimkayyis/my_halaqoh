import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/widgets/santri_picker_tile.dart';

/// Screen for selecting which santri to impersonate (wali santri perspective).
///
/// Uses the globally provided [SantriCubit].
@RoutePage()
class SantriPickerScreen extends StatefulWidget {
  const SantriPickerScreen({super.key});

  @override
  State<SantriPickerScreen> createState() => _SantriPickerScreenState();
}

class _SantriPickerScreenState extends State<SantriPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SantriModel> _filter(List<SantriModel> all) {
    // Exclude alumni from picker
    final active = all.where((s) => !s.isAlumni).toList();
    if (_searchQuery.isEmpty) return active;
    final q = _searchQuery.toLowerCase();
    return active
        .where((s) =>
            s.nama.toLowerCase().contains(q) ||
            s.nis.toLowerCase().contains(q))
        .toList();
  }

  void _selectSantri(BuildContext context, SantriModel santri) {
    context.read<ImpersonationCubit>().impersonateAsSantri(santri);
    final programStr = santri.program == 'T' ? 'takhassus' : 'reguler';
    context.router.replace(
      WaliSantriDashboardWrapperRoute(programType: programStr),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          // ── Header (Dark Teal with Back Button, Title, and Search Bar) ───────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32.r),
                bottomRight: Radius.circular(32.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  children: [
                    // Top Row: Back button & Centered Title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                          onPressed: () => context.router.pop(),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 48.w), // Balance the back button space
                            child: Text(
                              'Pilih Santri',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Search Bar inside Header
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari santri...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontFamily: 'Poppins',
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, color: Colors.white70),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Students List ────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<SantriCubit, SantriState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loaded: (santriList) {
                    final filtered = _filter(santriList);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada santri ditemukan',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => SizedBox(height: 14.h),
                      itemBuilder: (_, i) => SantriPickerTile(
                        santri: filtered[i],
                        onTap: () => _selectSantri(context, filtered[i]),
                      ),
                    );
                  },
                  error: (msg) => Center(
                    child: Text(
                      msg,
                      style: TextStyle(
                        color: colors.error,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
