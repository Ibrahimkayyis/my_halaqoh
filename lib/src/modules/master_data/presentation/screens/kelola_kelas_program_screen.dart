import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_state.dart';
import 'package:my_halaqoh/src/core/widget/tab/app_tab_selector.dart';

@RoutePage()
class KelolaKelasProgramScreen extends StatefulWidget {
  const KelolaKelasProgramScreen({super.key});

  @override
  State<KelolaKelasProgramScreen> createState() => _KelolaKelasProgramScreenState();
}

class _KelolaKelasProgramScreenState extends State<KelolaKelasProgramScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Fetch both datasets
    context.read<KelasCubit>().watchAll();
    context.read<ProgramCubit>().watchAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text(
          t.kelasProgram.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          AppTabSelector(
            controller: _tabController,
            tabs: [t.kelasProgram.kelasTab, t.kelasProgram.programTab],
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildKelasTab(colors),
                _buildProgramTab(colors),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── KELAS TAB ─────────────────────────────────────────────────────────────
  Widget _buildKelasTab(AppColorSet colors) {
    return BlocBuilder<KelasCubit, KelasState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (msg) => Center(
            child: Text(
              msg,
              style: TextStyle(fontFamily: 'Poppins', color: colors.error),
            ),
          ),
          loaded: (kelasList) {
            if (kelasList.isEmpty) {
              return Center(
                child: Text(
                  t.kelasProgram.belumAdaKelas,
                  style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary),
                ),
              );
            }
            return Scaffold(
              backgroundColor: colors.background,
              floatingActionButton: FloatingActionButton(
                backgroundColor: colors.primary,
                onPressed: () => _showAddEditKelasDialog(null, kelasList),
                child: Icon(Icons.add, color: colors.textOnButton),
              ),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                itemCount: kelasList.length,
                itemBuilder: (context, index) {
                  final k = kelasList[index];
                  final nextKelas = k.nextKelasId != null
                      ? (kelasList.where((item) => item.id == k.nextKelasId).firstOrNull?.nama ?? k.nextKelasId!)
                      : t.kelasProgram.lulusAlumni;

                  return Card(
                    color: colors.surface,
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      title: Text(
                        t.kelasProgram.kelasNama(nama: k.nama),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        t.kelasProgram.urutanPromosi(urutan: k.urutan.toString(), nextKelas: nextKelas),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: colors.primary, size: 20.sp),
                            onPressed: () => _showAddEditKelasDialog(k, kelasList),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: colors.error, size: 20.sp),
                            onPressed: () => _confirmDeleteKelas(k),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // ─── PROGRAM TAB ───────────────────────────────────────────────────────────
  Widget _buildProgramTab(AppColorSet colors) {
    return BlocBuilder<ProgramCubit, ProgramState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Center(child: CircularProgressIndicator()),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (msg) => Center(
            child: Text(
              msg,
              style: TextStyle(fontFamily: 'Poppins', color: colors.error),
            ),
          ),
          loaded: (programList) {
            if (programList.isEmpty) {
              return Center(
                child: Text(
                  t.kelasProgram.belumAdaProgram,
                  style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary),
                ),
              );
            }
            return Scaffold(
              backgroundColor: colors.background,
              floatingActionButton: FloatingActionButton(
                backgroundColor: colors.primary,
                onPressed: () => _showAddEditProgramDialog(null),
                child: Icon(Icons.add, color: colors.textOnButton),
              ),
              body: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                itemCount: programList.length,
                itemBuilder: (context, index) {
                  final p = programList[index];

                  return Card(
                    color: colors.surface,
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: colors.border.withValues(alpha: 0.5)),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      title: Text(
                        p.nama,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: colors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        t.kelasProgram.programId(id: p.id),
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: colors.primary, size: 20.sp),
                            onPressed: () => _showAddEditProgramDialog(p),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: colors.error, size: 20.sp),
                            onPressed: () => _confirmDeleteProgram(p),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // ─── CRUD DIALOGS KELAS ────────────────────────────────────────────────────
  void _showAddEditKelasDialog(KelasModel? existing, List<KelasModel> list) {
    final colors = AppColors.of(context);
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existing?.nama);
    final urutanCtrl = TextEditingController(text: existing?.urutan.toString() ?? '');

    VoidCallback? onNameChanged;
    nameCtrl.addListener(() {
      onNameChanged?.call();
    });

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            onNameChanged = () {
              if (ctx.mounted) {
                setDialogState(() {});
              }
            };

            return AlertDialog(
              backgroundColor: colors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              title: Text(
                existing == null ? t.kelasProgram.tambahKelas : t.kelasProgram.editKelas,
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.textPrimary),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.kelasProgram.namaKelas,
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13.sp, color: colors.textPrimary),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          hintText: t.kelasProgram.namaKelasHint,
                          hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                        ),
                        validator: (v) => v == null || v.isEmpty ? t.kelasProgram.namaKelasRequired : null,
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.kelasProgram.urutanKelas,
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13.sp, color: colors.textPrimary),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextFormField(
                        controller: urutanCtrl,
                        decoration: InputDecoration(
                          hintText: t.kelasProgram.urutanKelasHint,
                          hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty) return t.kelasProgram.urutanRequired;
                          if (int.tryParse(v) == null) return t.kelasProgram.urutanNumeric;
                          return null;
                        },
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.kelasProgram.kelasSelanjutnya,
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13.sp, color: colors.textPrimary),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextFormField(
                        key: ValueKey(nameCtrl.text),
                        initialValue: _getNextKelasLabel(nameCtrl.text, list),
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: t.kelasProgram.kelasSelanjutnya,
                          hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                          fillColor: colors.surface.withValues(alpha: 0.5),
                        ),
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 14.sp, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(t.kelasProgram.batal, style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final now = DateTime.now();
                      final targetId = existing?.id ?? FirebaseFirestore.instance.collection('kelas').doc().id;
                      final targetNama = nameCtrl.text.trim();
                      final targetUrutan = int.parse(urutanCtrl.text.trim());

                      // 1. Build updated list of all classes representing the state after save
                      final updatedList = list.map((k) {
                        if (k.id == targetId) {
                          return k.copyWith(
                            nama: targetNama,
                            urutan: targetUrutan,
                          );
                        }
                        return k;
                      }).toList();

                      if (existing == null) {
                        updatedList.add(KelasModel(
                          id: targetId,
                          nama: targetNama,
                          urutan: targetUrutan,
                          nextKelasId: null,
                          createdAt: now,
                          updatedAt: now,
                        ));
                      }

                      // 2. Recalculate nextKelasId for all classes in updatedList
                      final finalizedList = updatedList.map((k) {
                        final val = int.tryParse(k.nama);
                        String? computedNextId;
                        if (val != null && val < 12) {
                          final nextName = (val + 1).toString();
                          try {
                            final nextKelas = updatedList.firstWhere((item) => item.nama == nextName);
                            computedNextId = nextKelas.id;
                          } catch (_) {
                            computedNextId = null;
                          }
                        } else {
                          computedNextId = null;
                        }
                        return k.copyWith(nextKelasId: computedNextId, updatedAt: now);
                      }).toList();

                      final kelasCubit = context.read<KelasCubit>();
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        // 3. Save the main target class
                        final targetModel = finalizedList.firstWhere((k) => k.id == targetId);
                        if (existing == null) {
                          await kelasCubit.addKelas(targetModel);
                        } else {
                          await kelasCubit.updateKelas(targetModel);
                        }

                        // 4. Update other classes whose nextKelasId has changed
                        for (final k in finalizedList) {
                          if (k.id == targetId) continue;
                          final original = list.firstWhere((item) => item.id == k.id);
                          if (original.nextKelasId != k.nextKelasId) {
                            await kelasCubit.updateKelas(k);
                          }
                        }

                        if (context.mounted && ctx.mounted) Navigator.of(ctx).pop();
                      } catch (e) {
                        if (context.mounted) {
                          messenger.showSnackBar(
                            SnackBar(content: Text(t.kelasProgram.gagalMenyimpan(error: e.toString()), style: const TextStyle(fontFamily: 'Poppins')), backgroundColor: colors.error),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                  child: Text(t.kelasProgram.simpan, style: TextStyle(fontFamily: 'Poppins', color: colors.textOnButton)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteKelas(KelasModel model) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            t.kelasProgram.hapusKelas,
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.error),
          ),
          content: Text(
            t.kelasProgram.hapusKelasConfirm(nama: model.nama),
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.kelasProgram.batal, style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final kelasCubit = context.read<KelasCubit>();
                final messenger = ScaffoldMessenger.of(context);

                // Get current list of classes before deletion
                final list = kelasCubit.state.maybeWhen(
                  loaded: (l) => l,
                  orElse: () => <KelasModel>[],
                );

                final success = await kelasCubit.deleteKelas(model.id);
                if (context.mounted && ctx.mounted) {
                  Navigator.of(ctx).pop();
                  if (!success) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(t.kelasProgram.gagalMenghapusKelas, style: const TextStyle(fontFamily: 'Poppins')), backgroundColor: colors.error),
                    );
                  } else {
                    // Update any class that pointed to the deleted class
                    for (final k in list) {
                      if (k.id != model.id && k.nextKelasId == model.id) {
                        await kelasCubit.updateKelas(k.copyWith(nextKelasId: null, updatedAt: DateTime.now()));
                      }
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: colors.error),
              child: Text(t.kelasProgram.hapus, style: TextStyle(fontFamily: 'Poppins', color: colors.textOnButton)),
            ),
          ],
        );
      },
    );
  }

  // ─── CRUD DIALOGS PROGRAM ──────────────────────────────────────────────────
  void _showAddEditProgramDialog(ProgramModel? existing) {
    final colors = AppColors.of(context);
    final formKey = GlobalKey<FormState>();
    final idCtrl = TextEditingController(text: existing?.id);
    final nameCtrl = TextEditingController(text: existing?.nama);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            existing == null ? t.kelasProgram.tambahProgram : t.kelasProgram.editProgram,
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.textPrimary),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.kelasProgram.kodeProgram,
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13.sp, color: colors.textPrimary),
                  ),
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: idCtrl,
                  enabled: existing == null, // ID is immutable once set (e.g. R, T, TH)
                  decoration: InputDecoration(
                    hintText: t.kelasProgram.kodeProgramHint,
                    hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                  ),
                  validator: (v) => v == null || v.isEmpty ? t.kelasProgram.kodeProgramRequired : null,
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    t.kelasProgram.namaProgram,
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 13.sp, color: colors.textPrimary),
                  ),
                ),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: t.kelasProgram.namaProgramHint,
                    hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12.sp),
                  ),
                  validator: (v) => v == null || v.isEmpty ? t.kelasProgram.namaProgramRequired : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.kelasProgram.batal, style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final now = DateTime.now();
                  final model = ProgramModel(
                    id: idCtrl.text.trim(),
                    nama: nameCtrl.text.trim(),
                    createdAt: existing?.createdAt ?? now,
                    updatedAt: now,
                  );
                  final programCubit = context.read<ProgramCubit>();
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    if (existing == null) {
                      await programCubit.addProgram(model);
                    } else {
                      await programCubit.updateProgram(model);
                    }
                    if (context.mounted && ctx.mounted) Navigator.of(ctx).pop();
                  } catch (e) {
                    if (context.mounted) {
                      messenger.showSnackBar(
                        SnackBar(content: Text(t.kelasProgram.gagalMenyimpan(error: e.toString()), style: const TextStyle(fontFamily: 'Poppins')), backgroundColor: colors.error),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
              child: Text(t.kelasProgram.simpan, style: TextStyle(fontFamily: 'Poppins', color: colors.textOnButton)),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteProgram(ProgramModel model) {
    final colors = AppColors.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            t.kelasProgram.hapusProgram,
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.error),
          ),
          content: Text(
            t.kelasProgram.hapusProgramConfirm(nama: model.nama, id: model.id),
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.kelasProgram.batal, style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () async {
                final programCubit = context.read<ProgramCubit>();
                final messenger = ScaffoldMessenger.of(context);
                final success = await programCubit.deleteProgram(model.id);
                if (context.mounted && ctx.mounted) {
                  Navigator.of(ctx).pop();
                  if (!success) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(t.kelasProgram.gagalMenghapusProgram, style: const TextStyle(fontFamily: 'Poppins')), backgroundColor: colors.error),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: colors.error),
              child: Text(t.kelasProgram.hapus, style: TextStyle(fontFamily: 'Poppins', color: colors.textOnButton)),
            ),
          ],
        );
      },
    );
  }

  String _getNextKelasLabel(String name, List<KelasModel> list) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return '-';
    final val = int.tryParse(cleanName);
    if (val != null) {
      if (val >= 12) {
        return t.kelasProgram.lulusAlumni;
      }
      final nextName = (val + 1).toString();
      final exists = list.any((item) => item.nama == nextName);
      if (exists) {
        return t.kelasProgram.kelasNama(nama: nextName);
      } else {
        return '${t.kelasProgram.kelasNama(nama: nextName)} (${t.kelasProgram.belumAdaKelas.toLowerCase()})';
      }
    }
    return t.kelasProgram.lulusAlumni;
  }

}
