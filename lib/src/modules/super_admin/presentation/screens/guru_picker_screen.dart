import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/widgets/guru_picker_tile.dart';

/// Screen for selecting which guru to impersonate.
///
/// Uses the globally provided [GuruCubit] — no additional data fetching needed.
@RoutePage()
class GuruPickerScreen extends StatefulWidget {
  const GuruPickerScreen({super.key});

  @override
  State<GuruPickerScreen> createState() => _GuruPickerScreenState();
}

class _GuruPickerScreenState extends State<GuruPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<GuruModel> _filter(List<GuruModel> all) {
    if (_searchQuery.isEmpty) return all;
    final q = _searchQuery.toLowerCase();
    return all
        .where((g) =>
            g.nama.toLowerCase().contains(q) ||
            g.nip.toLowerCase().contains(q))
        .toList();
  }

  void _selectGuru(BuildContext context, GuruModel guru) {
    context.read<ImpersonationCubit>().impersonateAsGuru(guru);
    final programStr = guru.program == 'T' ? 'takhassus' : 'reguler';
    context.router.replace(
      GuruDashboardWrapperRoute(programType: programStr),
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
                              'Pilih Guru',
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
                          hintText: 'Cari guru...',
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

          // ── Teachers List ────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<GuruCubit, GuruState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loaded: (guruList) {
                    final filtered = _filter(guruList);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada guru ditemukan',
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
                      itemBuilder: (_, i) => GuruPickerTile(
                        guru: filtered[i],
                        onTap: () => _selectGuru(context, filtered[i]),
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
